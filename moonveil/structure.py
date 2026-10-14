"""Structure reducible numeric-dispatch CFGs without goto or a numeric dispatcher.

Only graph shapes that this pass can account for are emitted. A failed coverage,
loop or join check is an unsupported result, not an invented implementation.
"""

from __future__ import annotations
import copy
from .front import Unsupported
from .cfg import leaves

EXIT = "$exit"


def successors(term):
    if "goto" in term:
        return [term["goto"]]
    if "cond" in term:
        if "goto" not in term["yes"] or "goto" not in term["no"]:
            raise Unsupported("Nested conditional CFG edge is not supported")
        return [term["yes"]["goto"], term["no"]["goto"]]
    return []


def postdom(nodes, adjacency):
    universe = set(nodes) | {EXIT}
    result = {n: ({EXIT} if n == EXIT else set(universe)) for n in universe}
    for _ in range(len(universe) + 2):
        changed = False
        for n in nodes:
            targets = adjacency.get(n) or [EXIT]
            common = set.intersection(*(result[t] for t in targets))
            value = {n} | common
            if value != result[n]:
                result[n] = value
                changed = True
        if not changed:
            return result
    raise Unsupported("Postdominator analysis failed to converge")


class Structurer:
    def __init__(self, graph):
        self.graph = graph
        self.nodes = graph["nodes"]
        self.start = graph["start"]
        self.succ = {n: successors(v["term"]) for n, v in self.nodes.items()}
        self.pred = {n: set() for n in self.nodes}
        for n, targets in self.succ.items():
            for t in targets:
                if t not in self.nodes:
                    raise Unsupported("CFG edge targets a missing state")
                self.pred[t].add(n)
        all_nodes = set(self.nodes)
        dom = {n: ({n} if n == self.start else set(all_nodes)) for n in all_nodes}
        for _ in range(len(all_nodes) + 2):
            changed = False
            for n in all_nodes - {self.start}:
                parents = self.pred[n]
                value = (
                    {n} | set.intersection(*(dom[p] for p in parents))
                    if parents
                    else {n}
                )
                if value != dom[n]:
                    dom[n] = value
                    changed = True
            if not changed:
                break
        else:
            raise Unsupported("Dominator analysis failed")
        self.loops = {}
        self.backs = set()
        for n, targets in self.succ.items():
            for t in targets:
                if t in dom[n]:
                    self.backs.add((n, t))
                    members = {n, t}
                    pending = [] if n == t else [n]
                    while pending:
                        cur = pending.pop()
                        for p in self.pred[cur]:
                            if p not in members:
                                members.add(p)
                                if p != t:
                                    pending.append(p)
                    self.loops.setdefault(t, set()).update(members)
        for head, members in self.loops.items():
            if any(head not in dom[n] for n in members):
                raise Unsupported("Irreducible loop entry")
            for other in self.loops.values():
                if members & other and not (members <= other or other <= members):
                    raise Unsupported("Overlapping non-nested loops")
        cut = {
            n: [t for t in targets if (n, t) not in self.backs] or [EXIT]
            for n, targets in self.succ.items()
        }
        pd = postdom(all_nodes, cut)
        self.exits = {}
        for head, members in self.loops.items():
            exits = {t for n in members for t in self.succ[n] if t not in members}
            if not exits:
                self.exits[head] = EXIT
                continue
            common = set.intersection(*(pd[t] for t in exits)) - members
            if not common:
                raise Unsupported("Loop has no representable continuation")
            self.exits[head] = max(common, key=lambda n: len(pd[n]))
        self.covered = set()
        self.emissions = 0
        self.depth = 0

    def emit(self):
        body = self._region(self.start, (), None, None)
        missing = set(self.nodes) - self.covered
        if missing:
            raise Unsupported(
                "Structuring omitted reachable states: " + repr(sorted(missing))
            )
        return (
            copy.deepcopy(self.graph["prefix"])
            + body
            + copy.deepcopy(self.graph["suffix"])
        )

    def _region(self, start, active, current_head, continuation):
        self.depth += 1
        if self.depth > 80:
            raise Unsupported("Nested control-flow limit exceeded")

        def target(t):
            return EXIT if t == EXIT or t == current_head or t == continuation else t

        adjacency = {}
        pending = [start]
        while pending:
            n = pending.pop()
            if n in adjacency or n == EXIT:
                continue
            if n in active and n != current_head:
                raise Unsupported("Multi-level continue is not supported")
            if n in self.loops and n not in active:
                targets = [target(self.exits[n])]
            else:
                targets = [target(t) for t in self.succ[n]] or [EXIT]
            adjacency[n] = list(dict.fromkeys(targets))
            pending.extend(t for t in targets if t != EXIT)
        pd = postdom(set(adjacency), adjacency)
        # Acyclic after collapsing child loops and cutting this loop's back edges.
        visiting = set()
        done = set()

        def acyclic(n):
            if n == EXIT or n in done:
                return
            if n in visiting:
                raise Unsupported("Irreducible residual control flow")
            visiting.add(n)
            for t in adjacency[n]:
                acyclic(t)
            visiting.remove(n)
            done.add(n)

        acyclic(start)
        in_progress = set()

        def sequence(cur, stop=EXIT, initial=False):
            output = []
            while True:
                if cur == EXIT or cur == stop:
                    return output
                if cur == current_head and not initial:
                    return output
                if cur == continuation:
                    output.append({"type": "BreakStatement"})
                    return output
                initial = False
                self.emissions += 1
                if self.emissions > 10000:
                    raise Unsupported("Structured output growth limit exceeded")
                if cur in in_progress:
                    raise Unsupported("Unexpected recursive region")
                in_progress.add(cur)
                if cur in self.loops and cur not in active:
                    nested = self._region(cur, active + (cur,), cur, self.exits[cur])
                    output.append(
                        {
                            "type": "WhileStatement",
                            "condition": {
                                "type": "BooleanLiteral",
                                "value": True,
                                "raw": "true",
                            },
                            "body": nested,
                        }
                    )
                    in_progress.remove(cur)
                    cur = self.exits[cur]
                    continue
                self.covered.add(cur)
                node = self.nodes[cur]
                output.extend(copy.deepcopy(node["stmts"]))
                term = node["term"]
                if "return" in term:
                    in_progress.remove(cur)
                    return output
                if "goto" in term:
                    in_progress.remove(cur)
                    cur = term["goto"]
                    continue
                common = pd[cur] - {cur}
                if not common:
                    raise Unsupported("Missing conditional join")
                join = max(common, key=lambda n: len(pd[n]))
                yes = sequence(term["yes"]["goto"], join)
                no = sequence(term["no"]["goto"], join)
                output.append(
                    {
                        "type": "IfStatement",
                        "clauses": [
                            {
                                "type": "IfClause",
                                "condition": copy.deepcopy(term["cond"]),
                                "body": yes,
                            },
                            {"type": "ElseClause", "body": no},
                        ],
                    }
                )
                in_progress.remove(cur)
                cur = join

        try:
            return sequence(start, initial=True)
        finally:
            self.depth -= 1
