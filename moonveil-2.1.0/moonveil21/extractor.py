"""Static/pure-loader analysis of the observed MoonVeil 2.1.0 container layouts.

This exports decoded constants, VM prototypes and opcode-handler source. It does
NOT label those intermediates as a completed decompilation. Clean reconstructions
for the two reviewed inputs are separate files in results/.
"""

from __future__ import annotations
import copy
import hashlib
import json
import math
import re
from dataclasses import dataclass
from .core import decoder
from .core.front import Unsupported, normalize, walk
from .core.staticlua import Table, Closure, Builtin, Env, Returned
from .core.cfg import expr
from .runtime import AnalysisEvaluator

REVIEWED = {
    "0e34cd19184467821dbe6a744b7fa1ef71eb6200b19a754d2f0b5061caf0ad76": "sample_6",
    "fb26e52ce09f4faa5625b0c1b0a15a213af6ffd35ba2db5d570cbf08f6d3c172": "sample_7",
}


def parser_source(raw):
    if b"MoonVeil 2.1.0" not in raw[:256]:
        raise Unsupported(
            "This profile expects the supplied MoonVeil 2.1.0 wrapper family"
        )
    text = normalize(raw).decode("latin1")
    token = re.compile(
        r'"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\'|--[^\n]*|\b([A-Za-z_]\w*)\s*\+=\s*([0-9]+)'
    )
    changes = []

    def lower(match):
        if not match.group(1):
            return match.group(0)
        changes.append(match.group(0))
        return match.group(1) + "=" + match.group(1) + "+" + match.group(2)

    return token.sub(lower, text).encode("latin1"), changes


def unbox(value):
    if not isinstance(value, Table) or not any(
        v is value for v in value.fields.values()
    ):
        raise Unsupported("Not a recognized capture cell")
    candidates = []
    for selector, slot in value.fields.items():
        if (
            isinstance(slot, (int, float))
            and not isinstance(slot, bool)
            and slot != selector
            and slot in value.fields
        ):
            candidate = value.get(slot)
            if isinstance(candidate, (Table, Closure, Builtin)):
                candidates.append(candidate)
    if len(candidates) != 1:
        raise Unsupported("Ambiguous capture-cell layout")
    return candidates[0]


def captures_of(fn, context):
    result = []
    env = fn.env
    for _ in range(8):
        if env is None:
            break
        for value in env.values.values():
            if not isinstance(value, Table) or value is context or not value.fields:
                continue
            try:
                items = {k: unbox(v) for k, v in value.fields.items()}
            except Unsupported:
                continue
            if items:
                result.append(items)
        env = env.parent
    if len(result) != 1:
        raise Unsupported("Could not uniquely identify VM closure captures")
    return result[0]


def driver_layout(fn):
    node = fn.node
    if len(node.get("parameters", [])) != 4:
        raise Unsupported("Not a VM dispatch driver")
    names = [p.get("name") for p in node["parameters"]]
    loops = [s for s in node["body"] if s["type"] == "WhileStatement"]
    if len(loops) != 1:
        raise Unsupported("Driver loop shape mismatch")
    loop = loops[0]
    first = loop["body"][0]
    if first["type"] != "LocalStatement" or len(first["init"]) != 1:
        raise Unsupported("Driver instruction fetch mismatch")
    fetch = first["init"][0]
    if (
        fetch["type"] != "IndexExpression"
        or fetch["base"]["type"] != "Identifier"
        or fetch["index"]["type"] != "Identifier"
    ):
        raise Unsupported("Driver instruction fetch mismatch")
    instruction_name = first["variables"][0]["name"]
    code_name = fetch["base"]["name"]
    pc_name = fetch["index"]["name"]
    code_field = None
    for s in node["body"]:
        if s["type"] == "LocalStatement":
            for v, init in zip(s["variables"], s["init"]):
                if (
                    v.get("name") == code_name
                    and init["type"] == "IndexExpression"
                    and init["base"].get("name") == names[0]
                    and init["index"]["type"] == "NumericLiteral"
                ):
                    code_field = init["index"]["value"]
    if code_field is None:
        raise Unsupported("Prototype instruction-list field is unknown")
    call = None
    for s in loop["body"]:
        if (
            s["type"] == "LocalStatement"
            and len(s["init"]) == 1
            and s["init"][0]["type"] == "CallExpression"
        ):
            c = s["init"][0]
            base = c["base"]
            if (
                base["type"] == "IndexExpression"
                and base["index"]["type"] == "IndexExpression"
                and base["index"]["base"].get("name") == instruction_name
            ):
                call = c
                break
    if call is None or call["base"]["index"]["index"]["type"] != "NumericLiteral":
        raise Unsupported("Opcode dispatch shape mismatch")
    op_field = call["base"]["index"]["index"]["value"]
    handlers_name = call["base"]["base"]["name"]
    handler_expr = None
    for s in node["body"]:
        if s["type"] == "LocalStatement":
            for v, init in zip(s["variables"], s["init"]):
                if v.get("name") == handlers_name:
                    handler_expr = init
    if handler_expr is None:
        raise Unsupported("Opcode table capture is unknown")
    arg_names = [a.get("name") for a in call["arguments"]]
    if len(arg_names) != 7:
        raise Unsupported("Unsupported opcode call arity")
    return {
        "code_field": code_field,
        "opcode_field": op_field,
        "instruction_argument": arg_names.index(instruction_name),
        "frame_argument": arg_names.index(names[0]),
        "register_argument": arg_names.index(names[1]),
        "next_pc_argument": arg_names.index(pc_name),
        "handler_expression": handler_expr,
    }


def scalar(value):
    if isinstance(value, bytes):
        return {
            "type": "bytes",
            "hex": value.hex(),
            "text": value.decode("utf-8", "replace"),
        }
    if value is None or isinstance(value, (str, bool, int)):
        return value
    if isinstance(value, float):
        return value if math.isfinite(value) else {"number": repr(value)}
    if isinstance(value, Builtin):
        return {"builtin": value.name}
    if isinstance(value, Closure):
        return {"closure_range": value.node.get("range")}
    if isinstance(value, Table):
        return {"table_entries": len(value.fields)}
    return {"type": type(value).__name__}


def alias_for(fn, exports):
    start, end = fn.node["range"]
    matches = []
    for key, outer in exports.items():
        if isinstance(key, bytes) and isinstance(outer, Closure):
            a, b = outer.node["range"]
            if a <= start and b >= end:
                matches.append((b - a, key.decode("ascii"), outer))
    if not matches:
        return None, None
    _, name, outer = min(matches, key=lambda x: x[0])
    return name, outer


def decoded_handler(fn, d):
    name, outer = alias_for(fn, d.evaluator.bootstrap_exports)
    if name is None:
        return "unknown_" + str(fn.node["range"][0]), fn.node
    recovered = d.exports.get(name)
    if recovered is not None:
        before = [n for n in walk(outer.node) if n.get("type") == "FunctionDeclaration"]
        after = [n for n in walk(recovered) if n.get("type") == "FunctionDeclaration"]
        if len(before) == len(after):
            for a, b in zip(before, after):
                if a.get("range") == fn.node["range"]:
                    return name, b
    return name, fn.node


def signature(code):
    return tuple(
        (
            pc,
            tuple(
                (k, v)
                for k, v in sorted(ins.fields.items())
                if isinstance(v, (int, float, bytes, bool, type(None)))
            ),
        )
        for pc, ins in sorted(code.fields.items())
    )


@dataclass
class VM:
    name: str
    program: Closure
    driver: Closure
    layout: dict
    prototypes: list
    handlers: dict
    handler_sources: dict

    def export(self):
        code_key = self.layout["code_field"]
        op_key = self.layout["opcode_field"]
        protos = []
        for label, p in self.prototypes:
            instructions = []
            for pc, ins in sorted(p.get(code_key).fields.items()):
                opcode = int(ins.get(op_key))
                instructions.append(
                    {
                        "pc": int(pc),
                        "opcode": opcode,
                        "handler": self.handlers.get(opcode),
                        "operands": {
                            str(int(k)): scalar(v)
                            for k, v in sorted(ins.fields.items())
                        },
                    }
                )
            protos.append(
                {
                    "name": label,
                    "metadata": {
                        str(k): scalar(v) for k, v in p.fields.items() if k != code_key
                    },
                    "instructions": instructions,
                }
            )
        return {
            "loader": self.name,
            "layout": {
                k: v for k, v in self.layout.items() if k != "handler_expression"
            },
            "opcode_map": self.handlers,
            "prototypes": protos,
        }


def extract_vm(name, program, d):
    e = d.evaluator
    captures = captures_of(program, d.context)
    possible = []
    for v in captures.values():
        if not isinstance(v, Closure):
            continue
        try:
            layout = driver_layout(v)
        except (Unsupported, KeyError, ValueError):
            continue
        possible.append((v, layout))
    if len(possible) != 1:
        raise Unsupported("VM driver not uniquely identified for " + name)
    driver, layout = possible[0]
    code_key = layout["code_field"]
    op_key = layout["opcode_field"]

    def is_proto(p):
        if not isinstance(p, Table) or not isinstance(p.get(code_key), Table):
            return False
        code = p.get(code_key)
        return bool(code.fields) and all(
            isinstance(i, Table) and isinstance(i.get(op_key), (int, float))
            for i in code.fields.values()
        )

    # The runtime frame can share the same instruction list as its descriptor.
    # Prefer the pure deserialized descriptor, not the frame holding helper functions.
    roots = [
        v
        for v in captures.values()
        if is_proto(v)
        and not any(isinstance(x, (Closure, Builtin)) for x in v.fields.values())
    ]
    if len(roots) != 1:
        raise Unsupported("VM prototype root is ambiguous")
    prototypes = []
    seen = set()

    def visit(p, label):
        if id(p) in seen:
            return
        if len(seen) > 500:
            raise Unsupported("Prototype count limit exceeded")
        seen.add(id(p))
        prototypes.append((label, p))
        for value in p.fields.values():
            if isinstance(value, Table):
                for index, child in value.fields.items():
                    if is_proto(child):
                        visit(child, label + "." + str(int(index)))

    visit(roots[0], "root")
    table = e.evaluate(layout["handler_expression"], driver.env)
    if not isinstance(table, Table):
        raise Unsupported("Opcode table is not a table")
    handlers = {}
    sources = {}
    for opcode, fn in table.fields.items():
        if not isinstance(opcode, (int, float)) or not isinstance(fn, Closure):
            raise Unsupported("Unknown opcode handler type")
        alias, node = decoded_handler(fn, d)
        if not re.fullmatch(r"[A-Za-z_][A-Za-z_0-9]*", alias):
            raise Unsupported("Unsafe handler identifier")
        handlers[int(opcode)] = alias
        sources[alias] = expr(node)
    for _, p in prototypes:
        for ins in p.get(code_key).fields.values():
            if int(ins.get(op_key)) not in handlers:
                raise Unsupported("Unmapped opcode")
    return VM(name, program, driver, layout, prototypes, handlers, sources)


def analyze(raw, seconds=120, max_steps=80000000):
    source, changes = parser_source(raw)
    # This package uses a private copy of the core, never mutates another installed toolkit.
    decoder.Evaluator = AnalysisEvaluator
    d = decoder.decode(source, seconds=seconds, max_steps=max_steps)
    loaders = []
    for name, fn in d.evaluator.bootstrap_exports.items():
        if not isinstance(name, bytes) or not isinstance(fn, Closure):
            continue
        body = fn.node["body"]
        if (
            len(body) != 1
            or body[0]["type"] != "ReturnStatement"
            or len(body[0]["arguments"]) != 1
        ):
            continue
        if body[0]["arguments"][0]["type"] != "CallExpression":
            continue
        if not any(
            n.get("type") == "StringLiteral" and len(n.get("value", "")) > 100
            for n in walk(body)
        ):
            continue
        label = name.decode("ascii")
        if not re.fullmatch(r"[A-Za-z_][A-Za-z_0-9]*", label):
            raise Unsupported("Unsafe loader identifier")
        loaders.append((label, fn))
    if not loaders:
        raise Unsupported("No supported packed VM loader was discovered")
    vms = []
    for name, fn in loaders:
        values = d.evaluator.call(fn, (d.context,))
        if len(values) != 1 or not isinstance(values[0], Closure):
            raise Unsupported("VM loader did not return a closure")
        vms.append(extract_vm(name, values[0], d))
    report = {
        "tool_version": "0.2.0",
        "input_sha256": hashlib.sha256(raw).hexdigest(),
        "input_bytes": len(raw),
        "obfuscator_header": "MoonVeil 2.1.0",
        "status": "vm_analysis_only",
        "universal_decompiler": False,
        "native_lua_vm_used": False,
        "program_entry_invoked": False,
        "constants_decoded": len(d.constants),
        "counter_assignments_lowered": changes,
        "vm_loaders": len(vms),
        "prototype_count": sum(len(v.prototypes) for v in vms),
        "instruction_records": sum(
            len(p.get(v.layout["code_field"]).fields)
            for v in vms
            for _, p in v.prototypes
        ),
        "pure_ast_steps": d.evaluator.steps,
        "clean_source_generated_automatically": False,
    }
    return d, vms, report


def trace_reviewed(d, vms, report):
    if report["input_sha256"] not in REVIEWED:
        raise Unsupported("Tracing is restricted to the two reviewed input hashes")
    e = d.evaluator
    events = []
    assertions = []
    lookup = {}
    code_labels = {}
    for vm in vms:
        for label, p in vm.prototypes:
            code = p.get(vm.layout["code_field"])
            lookup[(vm.name, signature(code))] = label
            code_labels[(vm.name, id(code))] = label
    original = e.call

    def call(fn, args):
        record = None
        registers = None
        if isinstance(fn, Builtin) and fn.name == "assert":
            assertions.append([scalar(v) for v in args])
        if len(args) == 7:
            for vm in vms:
                layout = vm.layout
                frame = args[layout["frame_argument"]]
                ins = args[layout["instruction_argument"]]
                if not isinstance(frame, Table) or not isinstance(ins, Table):
                    continue
                code = frame.get(layout["code_field"])
                if not isinstance(code, Table):
                    continue
                key = (vm.name, id(code))
                label = code_labels.get(key)
                if label is None:
                    label = lookup.get((vm.name, signature(code)))
                    if label is not None:
                        code_labels[key] = label
                if label is None:
                    continue
                pc = int(args[layout["next_pc_argument"]]) - 1
                if code.get(float(pc)) is not ins:
                    continue
                registers = args[layout["register_argument"]]
                record = {
                    "loader": vm.name,
                    "prototype": label,
                    "pc": pc,
                    "handler": vm.handlers[int(ins.get(layout["opcode_field"]))],
                    "before": {str(k): scalar(v) for k, v in registers.fields.items()},
                }
                events.append(record)
                break
        result = original(fn, args)
        if record is not None:
            record["after"] = {str(k): scalar(v) for k, v in registers.fields.items()}
            record["returns"] = [scalar(v) for v in result]
        return result

    e.call = call
    local = Env(d.entry.env)
    local.values[d.entry.node["parameters"][0]["name"]] = d.context
    try:
        e.block(d.entry.node["body"][-1:], local)
        returned = []
    except Returned as r:
        returned = list(map(scalar, r.values))
    finally:
        e.call = original
    coverage = {}
    for vm in vms:
        for label, p in vm.prototypes:
            visited = sorted(
                {
                    r["pc"]
                    for r in events
                    if r["loader"] == vm.name and r["prototype"] == label
                }
            )
            coverage[vm.name + "/" + label] = {
                "visited": visited,
                "not_executed": sorted(
                    set(int(k) for k in p.get(vm.layout["code_field"]).fields)
                    - set(visited)
                ),
            }
    return {
        "status": "reviewed_pure_ast_trace",
        "sample": REVIEWED[report["input_sha256"]],
        "assertions": assertions,
        "returns": returned,
        "events": events,
        "coverage": coverage,
        "coverage_note": "Record 13 in the 27-record closure-sum prototype is an upvalue-capture descriptor consumed by record 12, not a separately dispatched statement. A trace alone is not a general proof of decompilation.",
    }
