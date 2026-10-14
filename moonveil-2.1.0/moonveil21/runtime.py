"""Bounded pure-data evaluator for the observed MoonVeil 2.1.0 layouts.
No filesystem, network, OS calls, require, loadstring or Roblox API are exposed.
"""

import math, struct
from .core.staticlua import (
    Evaluator,
    Env,
    Table,
    Closure,
    Builtin,
    RuntimeEnvironment,
    Unsupported,
    truth,
)


class AnalysisTable(Table):
    def __init__(self):
        super().__init__()
        self.key_history = []

    def put(self, k, v):
        if v is not None and k not in self.key_history:
            self.key_history.append(k)
        super().put(k, v)


class AnalysisEvaluator(Evaluator):
    latest = None

    def table(self):
        self.allocations += 1
        if self.allocations > 100000:
            raise Unsupported("Table allocation budget")
        return AnalysisTable()

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        AnalysisEvaluator.latest = self
        self.formats = set()
        self.printed = []
        table = self.table()
        self.env.values["table"] = table
        self.env.values["_G"] = self.runtime

        def add_table(k, fn):
            table.put(k.encode(), Builtin("table." + k, fn))

        def unpack(t, i=1, j=None):
            j = int(t.length() if j is None else j)
            i = int(i)
            if j - i > 50000:
                raise Unsupported("unpack budget")
            return tuple(t.get(float(k)) for k in range(i, j + 1))

        unpack_builtin = Builtin("unpack", unpack)
        self.env.values["unpack"] = unpack_builtin
        table.put(b"unpack", unpack_builtin)

        def pack(*args):
            t = self.table()
            for i, v in enumerate(args, 1):
                t.put(float(i), v)
            t.put(b"n", float(len(args)))
            return (t,)

        add_table("pack", pack)

        def concat(t, sep=b"", i=1, j=None):
            return (self.bounded(sep.join(self.as_string(v) for v in unpack(t, i, j))),)

        add_table("concat", concat)

        def insert(t, *args):
            length = int(t.length())
            if len(args) == 1:
                pos, val = length + 1, args[0]
            else:
                pos, val = int(args[0]), args[1]
            for k in range(length, pos - 1, -1):
                t.put(float(k + 1), t.get(float(k)))
            t.put(float(pos), val)
            return ()

        add_table("insert", insert)

        def remove(t, pos=None):
            length = int(t.length())
            pos = length if pos is None else int(pos)
            v = t.get(float(pos))
            for k in range(pos, length):
                t.put(float(k), t.get(float(k + 1)))
            t.put(float(length), None)
            return (v,)

        add_table("remove", remove)

        def create(n, v=None):
            n = int(n)
            if n < 0 or n > 50000:
                raise Unsupported("table.create budget")
            t = self.table()
            if v is not None:
                for k in range(1, n + 1):
                    t.put(float(k), v)
            return (t,)

        add_table("create", create)

        def move(a, f, e, t, d=None):
            d = a if d is None else d
            f, e, t = int(f), int(e), int(t)
            if e - f > 50000:
                raise Unsupported("table.move budget")
            values = [a.get(float(k)) for k in range(f, e + 1)]
            for k, v in enumerate(values):
                d.put(float(t + k), v)
            return (d,)

        add_table("move", move)

        def meta(t, m):
            if not isinstance(t, Table) or not isinstance(m, Table):
                raise Unsupported("Unsupported metatable")
            if any(k not in (b"__index", b"__mode") for k in m.fields):
                raise Unsupported("Metatable operations are not enabled")
            index = m.get(b"__index")
            if index is not None and not isinstance(index, (Table, RuntimeEnvironment)):
                raise Unsupported("Callable metatable not allowed")
            t.analysis_meta = m
            return (t,)

        self.env.values["setmetatable"] = Builtin("setmetatable", meta)
        self.env.values["getmetatable"] = Builtin(
            "getmetatable", lambda t: (getattr(t, "analysis_meta", None),)
        )

        def nextfn(t, k=None):
            keys = getattr(t, "key_history", list(t.fields))
            index = 0 if k is None else keys.index(k) + 1
            while index < len(keys) and keys[index] not in t.fields:
                index += 1
            if index >= len(keys):
                return (None,)
            key = keys[index]
            return key, t.fields[key]

        next_builtin = Builtin("next", nextfn)
        self.env.values["next"] = next_builtin
        self.env.values["pairs"] = Builtin("pairs", lambda t: (next_builtin, t, None))

        def ipairs_it(t, k):
            k = float(k) + 1
            v = t.get(k)
            return (None,) if v is None else (k, v)

        ipairs_builtin = Builtin("ipairs.next", ipairs_it)
        self.env.values["ipairs"] = Builtin(
            "ipairs", lambda t: (ipairs_builtin, t, 0.0)
        )

        def number(v, base=None):
            try:
                if isinstance(v, bytes):
                    return (float(int(v, int(base))) if base is not None else float(v),)
                if isinstance(v, (int, float)) and not isinstance(v, bool):
                    return (float(v),)
                return (None,)
            except ValueError:
                return (None,)

        self.env.values["tonumber"] = Builtin("tonumber", number)
        self.env.values["tostring"] = Builtin(
            "tostring",
            lambda v: (
                (
                    b"nil"
                    if v is None
                    else (
                        b"true"
                        if v is True
                        else b"false" if v is False else self.as_string(v)
                    )
                ),
            ),
        )

        def capture_print(*args):
            self.printed.append(args)
            return ()

        self.env.values["print"] = Builtin("print[captured only]", capture_print)
        maths = self.env.values["math"]
        maths.put(b"huge", math.inf)
        maths.put(
            b"ldexp", Builtin("math.ldexp", lambda a, b: (math.ldexp(a, int(b)),))
        )
        maths.put(b"frexp", Builtin("math.frexp", lambda a: math.frexp(a)))
        maths.put(b"max", Builtin("math.max", lambda *a: (max(a),)))
        maths.put(b"min", Builtin("math.min", lambda *a: (min(a),)))
        self.strings.put(b"unpack", Builtin("string.unpack", self.string_unpack))
        self.strings.put(b"pack", Builtin("string.pack", self.string_pack))
        self.env.values["rawget"] = Builtin("rawget", lambda t, k: (t.get(k),))
        self.env.values["rawset"] = Builtin(
            "rawset", lambda t, k, v: (t.put(k, v) or t,)
        )

        def protected(fn, *args):
            # Capability/analysis failures must remain failures, not be concealed.
            return (True,) + self.call(fn, args)

        self.env.values["pcall"] = Builtin("pcall[pure only]", protected)

        def error(message=None, *args):
            raise Unsupported("Lua error during pure analysis: " + repr(message))

        self.env.values["error"] = Builtin("error", error)

        def assertion(condition, *args):
            if not truth(condition):
                raise AssertionError("Interpreted source assertion failed")
            return (condition,) + args

        self.env.values["assert"] = Builtin("assert", assertion)
        bit = self.env.values["bit32"]
        bit.put(
            b"btest",
            Builtin(
                "bit32.btest",
                lambda *args: (self.call(bit.get(b"band"), args)[0] != 0,),
            ),
        )
        self.patterns = set()

        def gmatch(data, pattern):
            self.patterns.add(pattern)
            if pattern and len(pattern) <= 32 and set(pattern) == {46}:
                width = len(pattern)
                values = [
                    (data[i : i + width],)
                    for i in range(0, len(data) - width + 1, width)
                ]
            else:
                raise Unsupported("Unknown gmatch pattern " + repr(pattern))
            index = [0]

            def iterator(*args):
                if index[0] >= len(values):
                    return (None,)
                result = values[index[0]]
                index[0] += 1
                return result

            return (Builtin("gmatch.iterator", iterator),)

        self.strings.put(b"gmatch", Builtin("string.gmatch", gmatch))

    def call(self, fn, args):
        try:
            return super().call(fn, args)
        except Exception as exc:
            if (
                type(exc).__name__ == "BootstrapReady"
                and not hasattr(self, "bootstrap_exports")
                and args
                and isinstance(args[0], Table)
            ):
                self.bootstrap_exports = dict(args[0].fields)
            raise

    def lookup(self, obj, k):
        if isinstance(obj, RuntimeEnvironment):
            if not isinstance(k, bytes):
                raise Unsupported("Non-string environment key")
            name = k.decode("ascii")
            if name not in self.env.values:
                raise Unsupported("Unavailable pure environment field: " + name)
            return self.env.values[name]
        if isinstance(obj, Table):
            v = obj.get(k)
            meta = getattr(obj, "analysis_meta", None)
            if v is None and meta is not None and meta.get(b"__index") is not None:
                return self.lookup(meta.get(b"__index"), k)
            return v
        return super().lookup(obj, k)

    def _format(self, fmt):
        self.formats.add(fmt)
        if not isinstance(fmt, bytes):
            raise Unsupported("Format must be bytes")
        text = fmt.decode("ascii")
        endian = "<"
        if text[:1] in ("<", ">", "="):
            endian = text[0] if text[0] != "=" else "<"
            text = text[1:]
        simple = {
            "B": "B",
            "b": "b",
            "d": "d",
            "f": "f",
            "I1": "B",
            "i1": "b",
            "I2": "H",
            "i2": "h",
            "I4": "I",
            "i4": "i",
            "I8": "Q",
            "i8": "q",
            "I": "I",
            "i": "i",
            "H": "H",
            "h": "h",
            "L": "Q",
            "l": "q",
            "j": "q",
            "J": "Q",
            "n": "d",
        }
        if text.startswith("c") and text[1:].isdigit():
            count = int(text[1:])
            if count > self.max_string:
                raise Unsupported("Fixed string format exceeds limit")
            return endian + str(count) + "s"
        if text not in simple:
            raise Unsupported("Unsupported binary format " + repr(fmt))
        return endian + simple[text]

    def string_unpack(self, fmt, data, position=1):
        format = self._format(fmt)
        position = int(position)
        if position < 0:
            position = len(data) + position + 1
        size = struct.calcsize(format)
        if position < 1 or position - 1 + size > len(data):
            raise Unsupported("Binary buffer overrun")
        values = struct.unpack_from(format, data, position - 1)
        return tuple(v if isinstance(v, bytes) else float(v) for v in values) + (
            float(position + size),
        )

    def string_pack(self, fmt, *values):
        f = self._format(fmt)
        args = values if f[-1:] in ("f", "d") else tuple(int(v) for v in values)
        return (struct.pack(f, *args),)
