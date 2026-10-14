"""Small bounded AST interpreter for *pure decoder expressions*, not a Lua runtime.

No eval/exec, Lua VM, filesystem, OS, network, Python-object bridge, Roblox APIs,
loadstring, require or user-defined metatables are available to the input.
Unknown operations fail closed. It is still not a replacement for process isolation
when accepting adversarial uploads: use the supplied container and job limits.
"""

from __future__ import annotations
import math
import re
import time
from dataclasses import dataclass
from .front import Unsupported, lua_bytes


def truth(v):
    return v is not None and v is not False


def key(k):
    if k is None:
        raise Unsupported("nil table key in decoder")
    if isinstance(k, bool):
        return ("boolean", k)
    if isinstance(k, float) and math.isnan(k):
        raise Unsupported("NaN table key")
    return k


class Table:
    def __init__(self):
        self.fields = {}

    def get(self, k):
        return self.fields.get(key(k))

    def put(self, k, v):
        k = key(k)
        if v is None:
            self.fields.pop(k, None)
        else:
            if len(self.fields) >= 50000 and k not in self.fields:
                raise Unsupported("Decoder table limit exceeded")
            self.fields[k] = v

    def length(self):
        i = 1
        while i in self.fields:
            i += 1
        return float(i - 1)


class RuntimeEnvironment:
    """A deliberately inaccessible marker for the eventual payload environment."""


class Env:
    def __init__(self, parent=None):
        self.parent, self.values = parent, {}
        self.varargs = parent.varargs if parent is not None else ()

    def get(self, name):
        if name in self.values:
            return self.values[name]
        if self.parent is not None:
            return self.parent.get(name)
        raise Unsupported("Unavailable decoder global: " + name)

    def set(self, name, value):
        e = self
        while e.parent is not None and name not in e.values:
            e = e.parent
        if name not in e.values:
            raise Unsupported("Decoder attempted a global write: " + name)
        e.values[name] = value


@dataclass(eq=False)
class Closure:
    node: dict
    env: Env


@dataclass(eq=False)
class Builtin:
    name: str
    fn: object


class Returned(Exception):
    def __init__(self, values):
        self.values = values


class Broke(Exception):
    """Internal loop-control signal."""


class Evaluator:
    def __init__(self, max_steps=50000000, seconds=120):
        self.steps, self.max_steps = 0, max_steps
        self.deadline = time.monotonic() + seconds
        self.depth, self.max_string, self.allocations = 0, 2 * 1024 * 1024, 0
        self.call_hook = None
        self.env = Env()
        self.runtime = RuntimeEnvironment()
        self._builtins()

    def tick(self):
        self.steps += 1
        if self.steps > self.max_steps:
            raise Unsupported("Pure decoder instruction budget exceeded")
        if self.steps % 4096 == 0 and time.monotonic() > self.deadline:
            raise Unsupported("Pure decoder time limit exceeded")

    def table(self):
        self.allocations += 1
        if self.allocations > 100000:
            raise Unsupported("Decoder table allocation budget exceeded")
        return Table()

    def bounded(self, s):
        if len(s) > self.max_string:
            raise Unsupported("Decoder string limit exceeded")
        return s

    def lookup(self, obj, k):
        if isinstance(obj, Table):
            return obj.get(k)
        if isinstance(obj, bytes):
            return self.strings.get(k)
        if isinstance(obj, RuntimeEnvironment):
            raise Unsupported("Decoder attempted to read the payload environment")
        raise Unsupported("Unsupported indexing during pure evaluation")

    def exprlist(self, nodes, env):
        values = []
        for i, node in enumerate(nodes):
            multi = i == len(nodes) - 1 and not node.get("inParens")
            v = self.evaluate(node, env, multi)
            values.extend(v if multi else (v,))
        return tuple(values)

    def evaluate(self, n, env=None, multi=False):
        self.tick()
        env = self.env if env is None else env
        t = n["type"]
        if t == "NumericLiteral":
            result = float(n["value"])
        elif t == "StringLiteral":
            result = lua_bytes(n["value"])
        elif t in ("BooleanLiteral", "NilLiteral"):
            result = n.get("value")
        elif t == "Identifier":
            result = env.get(n["name"])
        elif t == "VarargLiteral":
            return env.varargs if multi else (env.varargs[0] if env.varargs else None)
        elif t == "FunctionDeclaration":
            result = Closure(n, env)
        elif t == "TableConstructorExpression":
            result = self.table()
            idx = 1
            for pos, field in enumerate(n["fields"]):
                ft = field["type"]
                if ft == "TableValue":
                    vals = self.evaluate(
                        field["value"],
                        env,
                        pos == len(n["fields"]) - 1
                        and not field["value"].get("inParens"),
                    )
                    if pos != len(n["fields"]) - 1 or field["value"].get("inParens"):
                        vals = (vals,)
                    for value in vals:
                        result.put(float(idx), value)
                        idx += 1
                else:
                    k = (
                        field["key"]["name"].encode("ascii")
                        if ft == "TableKeyString"
                        else self.evaluate(field["key"], env)
                    )
                    result.put(k, self.evaluate(field["value"], env))
        elif t in ("IndexExpression", "MemberExpression"):
            k = (
                self.evaluate(n["index"], env)
                if t == "IndexExpression"
                else n["identifier"]["name"].encode("ascii")
            )
            result = self.lookup(self.evaluate(n["base"], env), k)
        elif t in ("CallExpression", "StringCallExpression", "TableCallExpression"):
            base = n["base"]
            receiver = None
            is_method = base["type"] == "MemberExpression" and base["indexer"] == ":"
            if is_method:
                receiver = self.evaluate(base["base"], env)
                fn = self.lookup(receiver, base["identifier"]["name"].encode("ascii"))
            else:
                fn = self.evaluate(base, env)
            if t == "CallExpression":
                args = self.exprlist(n["arguments"], env)
            elif t == "StringCallExpression":
                args = (self.evaluate(n["argument"], env),)
            else:
                args = (self.evaluate(n["arguments"], env),)
            if is_method:
                args = (receiver,) + args
            vals = self.call(fn, args)
            return (
                vals
                if multi and not n.get("inParens")
                else (
                    (vals[0] if vals else None,)
                    if multi
                    else (vals[0] if vals else None)
                )
            )
        elif t == "UnaryExpression":
            v = self.evaluate(n["argument"], env)
            op = n["operator"]
            if op == "not":
                result = not truth(v)
            elif op == "-":
                result = -self.number(v)
            elif op == "#":
                if isinstance(v, Table):
                    result = v.length()
                elif isinstance(v, bytes):
                    result = float(len(v))
                else:
                    raise Unsupported("Unsupported length operand")
            else:
                raise Unsupported("Unsupported unary operator: " + op)
        elif t in ("BinaryExpression", "LogicalExpression"):
            op = n["operator"]
            a = self.evaluate(n["left"], env)
            if op == "and":
                result = self.evaluate(n["right"], env) if truth(a) else a
            elif op == "or":
                result = a if truth(a) else self.evaluate(n["right"], env)
            else:
                b = self.evaluate(n["right"], env)
                if op in ("==", "~="):
                    eq = a == b and (
                        not isinstance(a, bool)
                        and not isinstance(b, bool)
                        or type(a) is type(b)
                    )
                    result = eq if op == "==" else not eq
                elif op in ("<", "<=", ">", ">="):
                    if not (
                        (
                            isinstance(a, (int, float))
                            and not isinstance(a, bool)
                            and isinstance(b, (int, float))
                            and not isinstance(b, bool)
                        )
                        or isinstance(a, bytes)
                        and isinstance(b, bytes)
                    ):
                        raise Unsupported("Incomparable pure operands")
                    result = {
                        "<": lambda: a < b,
                        "<=": lambda: a <= b,
                        ">": lambda: a > b,
                        ">=": lambda: a >= b,
                    }[op]()
                elif op == "..":
                    result = self.bounded(self.as_string(a) + self.as_string(b))
                else:
                    a, b = self.number(a), self.number(b)
                    if op == "+":
                        result = a + b
                    elif op == "-":
                        result = a - b
                    elif op == "*":
                        result = a * b
                    elif op == "/":
                        result = (
                            a / b
                            if b
                            else (math.nan if not a else math.copysign(math.inf, a))
                        )
                    elif op == "%":
                        result = a % b if b else math.nan
                    elif op == "^":
                        try:
                            result = math.pow(a, b)
                        except (ValueError, OverflowError) as e:
                            raise Unsupported("Unsupported power result") from e
                    else:
                        raise Unsupported("Unsupported numeric operator: " + op)
        else:
            raise Unsupported("Unsupported decoder expression: " + t)
        return (result,) if multi else result

    @staticmethod
    def number(v):
        if isinstance(v, bool) or not isinstance(v, (int, float)):
            raise Unsupported("Non-numeric decoder arithmetic")
        return float(v)

    @staticmethod
    def as_string(v):
        if isinstance(v, bytes):
            return v
        if isinstance(v, (int, float)) and not isinstance(v, bool):
            return format(v, ".14g").encode("ascii")
        raise Unsupported("Unsupported decoder string conversion")

    def call(self, fn, args):
        self.tick()
        if self.call_hook is not None:
            self.call_hook(fn, args)
        if isinstance(fn, Builtin):
            return tuple(fn.fn(*args))
        if not isinstance(fn, Closure):
            raise Unsupported("Attempt to call an unknown decoder value")
        self.depth += 1
        if self.depth > 120:
            raise Unsupported("Decoder call-depth limit exceeded")
        local = Env(fn.env)
        local.varargs = ()
        parameters = fn.node["parameters"]
        for i, p in enumerate(parameters):
            if p["type"] == "VarargLiteral":
                local.varargs = args[i:]
                break
            local.values[p["name"]] = args[i] if i < len(args) else None
        try:
            self.block(fn.node["body"], local)
        except Returned as r:
            return r.values
        finally:
            self.depth -= 1
        return ()

    def block(self, statements, env):
        for s in statements:
            self.statement(s, env)

    def statement(self, s, env):
        self.tick()
        t = s["type"]
        if t in ("AssignmentStatement", "LocalStatement"):
            refs = []
            if t == "AssignmentStatement":
                for v in s["variables"]:
                    if v["type"] == "Identifier":
                        refs.append(("var", v["name"]))
                    else:
                        k = (
                            v["identifier"]["name"].encode("ascii")
                            if v["type"] == "MemberExpression"
                            else self.evaluate(v["index"], env)
                        )
                        table = self.evaluate(v["base"], env)
                        if not isinstance(table, Table):
                            raise Unsupported("Decoder attempted an external write")
                        refs.append(("index", table, k))
            vals = self.exprlist(s["init"], env)
            for i, v in enumerate(s["variables"]):
                value = vals[i] if i < len(vals) else None
                if t == "LocalStatement":
                    env.values[v["name"]] = value
                elif refs[i][0] == "var":
                    env.set(refs[i][1], value)
                else:
                    refs[i][1].put(refs[i][2], value)
        elif t == "ReturnStatement":
            raise Returned(self.exprlist(s["arguments"], env))
        elif t == "CallStatement":
            self.evaluate(s["expression"], env)
        elif t == "IfStatement":
            for c in s["clauses"]:
                if "condition" not in c or truth(self.evaluate(c["condition"], env)):
                    self.block(c["body"], Env(env))
                    break
        elif t == "WhileStatement":
            while truth(self.evaluate(s["condition"], env)):
                try:
                    self.block(s["body"], Env(env))
                except Broke:
                    break
        elif t == "RepeatStatement":
            while True:
                local = Env(env)
                try:
                    self.block(s["body"], local)
                except Broke:
                    break
                if truth(self.evaluate(s["condition"], local)):
                    break
        elif t == "DoStatement":
            self.block(s["body"], Env(env))
        elif t == "BreakStatement":
            raise Broke()
        elif t == "FunctionDeclaration":
            if s["identifier"]["type"] != "Identifier":
                raise Unsupported("Unsupported decoder function declaration")
            fn = Closure(s, env)
            if s.get("isLocal"):
                env.values[s["identifier"]["name"]] = fn
            else:
                env.set(s["identifier"]["name"], fn)
        elif t == "ForNumericStatement":
            initial = self.number(self.evaluate(s["start"], env))
            last = self.number(self.evaluate(s["end"], env))
            step = self.number(self.evaluate(s["step"], env)) if s.get("step") else 1.0
            if step == 0:
                raise Unsupported("Zero-step decoder loop")
            counter = initial
            while counter <= last if step > 0 else counter >= last:
                local = Env(env)
                local.values[s["variable"]["name"]] = counter
                try:
                    self.block(s["body"], local)
                except Broke:
                    break
                counter += step
        else:
            raise Unsupported("Unsupported pure decoder statement: " + t)

    def _builtins(self):
        def builtin(name, fn):
            return Builtin(name, fn)

        def add(name, fn):
            self.env.values[name] = builtin(name, fn)

        self.strings = self.table()
        bits = self.table()
        maths = self.table()
        self.env.values.update(string=self.strings, bit32=bits, math=maths)
        add("getfenv", lambda *args: (self.runtime,))
        add(
            "select",
            lambda i, *args: (
                (float(len(args)),)
                if i == b"#"
                else args[int(i) - 1 :] if i > 0 else args[len(args) + int(i) :]
            ),
        )
        add(
            "type",
            lambda v: (
                (
                    b"nil"
                    if v is None
                    else (
                        b"boolean"
                        if isinstance(v, bool)
                        else (
                            b"number"
                            if isinstance(v, (float, int))
                            else (
                                b"string"
                                if isinstance(v, bytes)
                                else (
                                    b"function"
                                    if isinstance(v, (Closure, Builtin))
                                    else b"table"
                                )
                            )
                        )
                    )
                ),
            ),
        )
        # Captured by the generic-iterator adapter; no metatables are supported here.
        add("getmetatable", lambda v: (None,))

        def unsupported_iterator(*args):
            raise Unsupported("Pure generic iteration is not supported")

        add("pairs", unsupported_iterator)
        add("ipairs", unsupported_iterator)

        def unsigned(v):
            n = self.number(v)
            if not math.isfinite(n) or n != math.trunc(n):
                raise Unsupported("Non-integral bit32 operand")
            return int(n) & 0xFFFFFFFF

        for name in ("band", "bor", "bxor"):

            def bitop(*args, _name=name):
                result = 0xFFFFFFFF if _name == "band" else 0
                for arg in args:
                    val = unsigned(arg)
                    result = (
                        result & val
                        if _name == "band"
                        else result | val if _name == "bor" else result ^ val
                    )
                return (float(result),)

            bits.put(name.encode(), builtin("bit32." + name, bitop))
        bits.put(
            b"bnot",
            builtin("bit32.bnot", lambda a: (float((~unsigned(a)) & 0xFFFFFFFF),)),
        )
        for name in ("lshift", "rshift"):

            def shift(a, b, _name=name):
                shift = int(self.number(b))
                val = unsigned(a)
                left = (_name == "lshift") if shift >= 0 else (_name != "lshift")
                shift = abs(shift)
                return (
                    float(
                        0
                        if shift >= 32
                        else ((val << shift) & 0xFFFFFFFF) if left else val >> shift
                    ),
                )

            bits.put(name.encode(), builtin("bit32." + name, shift))

        def substring(s, i=1, j=None):
            if not isinstance(s, bytes):
                raise Unsupported("Expected byte string")
            n = len(s)
            i = int(i)
            j = n if j is None else int(j)
            i = n + i + 1 if i < 0 else i
            j = n + j + 1 if j < 0 else j
            return s[max(i, 1) - 1 : min(j, n)] if min(j, n) >= max(i, 1) else b""

        self.strings.put(
            b"sub", builtin("string.sub", lambda s, i=1, j=None: (substring(s, i, j),))
        )
        self.strings.put(
            b"byte",
            builtin(
                "string.byte",
                lambda s, i=1, j=None: tuple(
                    float(x) for x in substring(s, i, i if j is None else j)
                ),
            ),
        )

        def chars(*args):
            if len(args) > self.max_string:
                raise Unsupported("String allocation limit")
            vals = [int(self.number(v)) for v in args]
            if any(v < 0 or v > 255 for v in vals):
                raise Unsupported("Out-of-range string.char")
            return (bytes(vals),)

        self.strings.put(b"char", builtin("string.char", chars))

        def repeat(s, n, sep=b""):
            n = int(n)
            if (
                not isinstance(s, bytes)
                or not isinstance(sep, bytes)
                or n > self.max_string
            ):
                raise Unsupported("Unsupported string.rep arguments")
            if n <= 0:
                return (b"",)
            if len(s) * n + len(sep) * (n - 1) > self.max_string:
                raise Unsupported("String allocation limit")
            return (sep.join([s] * n),)

        self.strings.put(b"rep", builtin("string.rep", repeat))
        self.strings.put(b"len", builtin("string.len", lambda s: (float(len(s)),)))
        self.strings.put(b"lower", builtin("string.lower", lambda s: (s.lower(),)))

        def find(s, pattern, init=1, plain=False):
            if plain is not True:
                raise Unsupported("Only plain string.find is allowed in pure decoders")
            init = int(init)
            init = len(s) + init + 1 if init < 0 else max(1, init)
            pos = s.find(pattern, init - 1)
            return (None,) if pos < 0 else (float(pos + 1), float(pos + len(pattern)))

        self.strings.put(b"find", builtin("string.find", find))

        def gsub(s, pattern, replacement, limit=None):
            if not isinstance(s, bytes) or not isinstance(pattern, bytes):
                raise Unsupported("Unsupported gsub input")
            # MoonVeil base85 uses fixed-width dot groups. No arbitrary Python regex.
            if pattern and len(pattern) <= 64 and set(pattern) == {46}:
                width = len(pattern)
                ranges = [(i, i + width) for i in range(0, len(s) - width + 1, width)]
            elif pattern == b"%s+":
                ranges = [
                    (m.start(), m.end()) for m in re.finditer(rb"[\t\n\v\f\r ]+", s)
                ]
            else:
                raise Unsupported("Unsupported pure gsub pattern")
            if limit is not None:
                ranges = ranges[: max(0, int(limit))]
            pieces = []
            end = 0
            total = 0
            for start, stop in ranges:
                pieces.append(s[end:start])
                if isinstance(replacement, (Closure, Builtin)):
                    values = self.call(replacement, (s[start:stop],))
                    v = values[0] if values else None
                    v = s[start:stop] if v is None or v is False else self.as_string(v)
                elif isinstance(replacement, bytes) and b"%" not in replacement:
                    v = replacement
                else:
                    raise Unsupported("Unsupported pure gsub replacement")
                pieces.append(v)
                total += len(v) + start - end
                if total > self.max_string:
                    raise Unsupported("String allocation limit")
                end = stop
            pieces.append(s[end:])
            return (self.bounded(b"".join(pieces)), float(len(ranges)))

        self.strings.put(b"gsub", builtin("string.gsub", gsub))
        for name, fn in [("floor", math.floor), ("ceil", math.ceil), ("abs", abs)]:
            maths.put(
                name.encode(),
                builtin(
                    "math." + name, lambda v, _fn=fn: (float(_fn(self.number(v))),)
                ),
            )
