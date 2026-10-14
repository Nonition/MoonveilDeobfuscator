"""Reusable profile pipeline. No filename/hash lookup selects a recovered program."""

from __future__ import annotations
import copy
import hashlib
import json
import re
from .front import Unsupported, parse, walk
from .decoder import decode
from .staticlua import Closure
from .cfg import build_graph, expr, block
from .structure import Structurer

KEYWORDS = set(
    "and break do else elseif end false for function if in local nil not or repeat return then true until while".split()
)


def _member(base, name):
    return {
        "type": "MemberExpression",
        "base": base,
        "indexer": ".",
        "identifier": {"type": "Identifier", "name": name},
    }


def clean(node):
    if isinstance(node, list):
        return [clean(v) for v in node]
    if not isinstance(node, dict):
        return node
    n = {k: clean(v) for k, v in node.items() if k not in ("range", "loc")}
    if n.get("type") == "IndexExpression":
        base = n["base"]
        index = n["index"]
        if (
            base.get("type") == "IndexExpression"
            and base["index"].get("value") == 2
            and index.get("type") == "IndexExpression"
            and index["index"].get("value") == 3
            and expr(base["base"]) == expr(index["base"])
        ):
            return _member(base["base"], "value")
        if index.get("type") == "StringLiteral":
            name = index["value"]
            if re.fullmatch(r"[A-Za-z_][A-Za-z_0-9]*", name) and name not in KEYWORDS:
                return _member(base, name)
    if n.get("type") == "TableConstructorExpression" and len(n["fields"]) == 2:
        fs = {
            f["key"].get("value"): f["value"]
            for f in n["fields"]
            if f["type"] == "TableKey"
        }
        if len(fs) == 2 and 1 in fs and fs.get(3, {}).get("value") == 1:
            n["fields"] = [
                {
                    "type": "TableKeyString",
                    "key": {"type": "Identifier", "name": "value"},
                    "value": fs[1],
                }
            ]
            n["_cell"] = True
    if "body" in n and isinstance(n["body"], list):
        n["body"] = clean_body(n["body"])
    if n.get("type") == "IfStatement":
        for clause in n["clauses"]:
            clause["body"] = clean_body(clause["body"])
    return n


def clean_body(statements):
    result = []
    recent_cells = set()
    for s in statements:
        if (
            s["type"] == "AssignmentStatement"
            and len(s["variables"]) == len(s["init"]) == 1
        ):
            v, initial = s["variables"][0], s["init"][0]
            if (
                v["type"] == "IndexExpression"
                and v["index"].get("value") == 2
                and expr(v["base"]) == expr(initial)
                and expr(initial) in recent_cells
            ):
                recent_cells = set()
                continue
        recent_cells = set()
        if s["type"] in ("LocalStatement", "AssignmentStatement"):
            recent_cells = {
                expr(v) for v, r in zip(s["variables"], s["init"]) if r.get("_cell")
            }
        if s["type"] == "IfStatement" and result:
            previous = result[-1]
            first = s["clauses"][0]
            if (
                previous["type"] == "LocalStatement"
                and len(previous["variables"]) == len(previous["init"]) == 1
                and previous["variables"][0].get("name", "").startswith("__mv_branch_")
                and first["condition"].get("type") == "Identifier"
                and first["condition"]["name"] == previous["variables"][0]["name"]
            ):
                first["condition"] = previous["init"][0]
                result.pop()
        if (
            s["type"] == "IfStatement"
            and len(s["clauses"]) == 2
            and not s["clauses"][1]["body"]
        ):
            s["clauses"].pop()
        result.append(s)
    return result


def dependencies(node, self_name):
    names = set()
    for n in walk(node):
        if (
            n.get("type") == "MemberExpression"
            and n["base"].get("type") == "Identifier"
            and n["base"]["name"] == self_name
        ):
            names.add(n["identifier"]["name"])
    return names


def reconstruct(decoded):
    entry_node = copy.deepcopy(decoded.entry.node)
    # The entry prelude only initializes the removed constant decoders.
    entry_node["body"] = entry_node["body"][-1:]
    entry_self = entry_node["parameters"][0]["name"]
    needed = dependencies(entry_node, entry_self)
    pending = list(needed)
    selected = {}
    while pending:
        name = pending.pop()
        if name in selected:
            continue
        if name not in decoded.exports:
            raise Unsupported(
                "Runtime still references an initialized decoder/unknown export: "
                + name
            )
        n = copy.deepcopy(decoded.exports[name])
        selected[name] = n
        if (
            n["type"] == "FunctionDeclaration"
            and n["parameters"]
            and n["parameters"][0]["type"] == "Identifier"
        ):
            deps = dependencies(n, n["parameters"][0]["name"])
            needed.update(deps)
            pending.extend(deps - set(selected))
    graphs = {}
    counts = {"functions_structured": 0, "states_accounted_for": 0}

    def transform(n, label):
        if isinstance(n, list):
            return [transform(x, label) for x in n]
        if not isinstance(n, dict):
            return n
        # Process nested closures first, not generated loops from a previous pass.
        result = {
            k: transform(v, label) for k, v in n.items() if k not in ("range", "loc")
        }
        if result.get("type") == "FunctionDeclaration":
            loops = [
                s
                for s in result["body"]
                if s["type"] in ("WhileStatement", "RepeatStatement")
            ]
            candidates = []
            for loop in loops:
                body = loop["body"]
                condition = (
                    body[0]["clauses"][0].get("condition", {})
                    if body and body[0]["type"] == "IfStatement"
                    else {}
                )
                if (
                    condition.get("type") == "BinaryExpression"
                    and condition["left"].get("type") == "Identifier"
                    and condition["right"].get("type") == "NumericLiteral"
                ):
                    candidates.append(loop)
            if candidates:
                if len(loops) != 1:
                    raise Unsupported("Multiple direct dispatcher loops in " + label)
                loop = candidates[0]
                if not (
                    loop["condition"].get("type") == "BooleanLiteral"
                    and loop["condition"]["value"] == (loop["type"] == "WhileStatement")
                ):
                    raise Unsupported(
                        "Non-constant dispatcher loop condition in " + label
                    )
                try:
                    graph = build_graph(result)
                    if graph is None:
                        raise Unsupported("Dispatcher could not be extracted")
                    body = Structurer(graph).emit()
                except (
                    AssertionError,
                    KeyError,
                    ValueError,
                    TypeError,
                    ZeroDivisionError,
                ) as e:
                    raise Unsupported(
                        "Control-flow profile mismatch in " + label + ": " + str(e)
                    ) from e
                graphs[label] = graph
                result["body"] = body
                counts["functions_structured"] += 1
                counts["states_accounted_for"] += len(graph["nodes"])
        return result

    selected = {name: clean(transform(n, name)) for name, n in selected.items()}
    taken = {n["name"] for n in walk(decoded.ast) if n.get("type") == "Identifier"}
    ctx = "__moonveil_recovered"
    while ctx in taken:
        ctx += "x"
    lines = [
        "-- MoonVeil 2.0.26 profile: automatically recovered code.",
        "-- Constants decoded; reachable numeric-dispatch states structurally accounted for.",
        "-- Names/comments lost before obfuscation are not recoverable by this pass.",
        "-- This is not a claim of universal coverage or live-runtime verification.",
        "local " + ctx + " = {}",
        "",
    ]
    for name, n in sorted(selected.items()):
        if not re.fullmatch(r"[A-Za-z_][A-Za-z_0-9]*", name) or name in KEYWORDS:
            raise Unsupported("Unsupported export identifier")
        lines.append("-- Recovered export: " + name)
        lines.append(ctx + "." + name + " = " + expr(n))
        lines.append("")
    entry_node["inParens"] = True
    lines.append("return " + expr(entry_node) + "(" + ctx + ", ...)")
    source = ("\n".join(lines) + "\n").encode("ascii")
    if len(source) > 2 * 1024 * 1024:
        raise Unsupported("Recovered source exceeds size limit")
    parse(source)
    return source, graphs, counts


def process(raw, mode="deobfuscate", seconds=120, max_steps=50000000):
    report = {
        "tool": "moonveil-toolkit",
        "tool_version": "0.1.0",
        "profile": "moonveil-2.0.26-table-dispatch-v1",
        "input_sha256": hashlib.sha256(raw).hexdigest(),
        "input_bytes": len(raw),
        "status": "unsupported",
        "payload_executed": False,
        "live_runtime_verified": False,
        "universal_support": False,
        "original_names_recovered": False,
    }
    d = decode(raw, seconds=seconds, max_steps=max_steps)
    report.update(
        constants_decoded=len(d.constants),
        pure_interpreter_steps=d.evaluator.steps,
        decoder_exports_discovered=len(d.exports),
        status="decoded_partial",
    )
    bundle = {
        "report": report,
        "constants": d.constants,
        "decoded": d.source,
        "graphs": {},
    }
    try:
        recovered, graphs, counts = reconstruct(d)
        report.update(
            counts, status="recovered_unverified", output_bytes=len(recovered)
        )
        bundle.update(recovered=recovered, graphs=graphs)
    except Unsupported as e:
        report["structure_error"] = str(e)
        if mode == "deobfuscate":
            # No misleading final .lua is created by the CLI on this status.
            return bundle
    return bundle
