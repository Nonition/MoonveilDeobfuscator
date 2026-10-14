# Support scope and how to extend

## Current support

Profile `moonveil-2.0.26-table-dispatch-v1` accepts this shape:

1. One outer `return` calling a bootstrap method on a table literal.
2. The bootstrap takes an export-name table and an entry name, mapping functions in the table.
3. The entry has an assignment-only prelude building decoders; only the final return invokes the payload.
4. Constants are cached per the `self.cache[key] or self:decoder(...)` pattern.
5. Decoders are expressible with the AST subset / pure builtins in `staticlua.py`.
6. Each function dispatcher has a numeric initial state, a `while true` / `repeat until false` loop, a numeric comparison tree, and inferable state edges.
7. The CFG has loops/branches that `structure.py` can structure without inventing edges or dropping nodes.

Function names, cache names, constant keys, and states are not pinned to RideAFish. The input's own bootstrap is used to infer the mapping. **No hash -> ready-source table, no AI API calls, no payload execution to harvest logs and fake a decompile.**

## No guarantee for all MoonVeil 2.0.26

The same banner/version may differ in options, templates, packers, VMs, or hand-edited variants. The banner is not compatibility evidence. Some explicit limits:

- Lua/Luau syntax outside the parser subset; type annotations, some Luau-specific extensions.
- Bytecode VMs, compressed/multi-layer loader payloads, environment/runtime-dependent decoders.
- Decoders needing non-whitelisted globals/builtins; custom metatables are not interpreted.
- Value-dependent state edges that cannot be inferred, nested state selectors not yet lowered, irreducible CFGs / multi-level continue.
- Float/bit operations or string patterns not simulated with certainty.
- Samples exceeding size, step, time, memory, or depth limits.
- Recovery of original variable names/comments erased by the obfuscator.
- Assurance that a game/API or endpoint key still exists or still works.

Automated output prioritizes preserving logic and multireturn/capture support, not guessing variable names. It can therefore be long and keep many temporaries/helper tables. The more readable manual reconstruction of the sample lives separately and is not engine output.

## Verification level

`recovered_unverified` only means: the supported pipeline ran to completion, no extracted reachable state was dropped, and the output parses. This is not a formal equivalence proof. Transformers may still have bugs; review the source and test against your runtime.

The 74-scenario regression suite only checks one known RideAFish sample: GUI, key dialog, toggles, some egg/token/remotes fixtures, and callbacks. It does not simulate all of Roblox, real timing, every error branch, every metamethod, or every game effect.

## Code layout

- `front.py`: lexer normalizing binary literals; vendored Node parser; byte-safe quoting.
- `staticlua.py`: budgeted pure AST interpreter with closed globals.
- `decoder.py`: pre-entry payload interception; cache resolution and collision-key detection.
- `cfg.py`: state/edge extraction, branch-selection timing preservation, Lua emitter.
- `structure.py`: dominators, natural loops, postdominators, and coverage checks.
- `pipeline.py`: reachable exports, structuring, cell/property cleanup.
- `cli.py`: report, artifacts, atomic output, and exit codes.
- `integrations/worker.py`: subprocess/container job adapter.

## When meeting a new sample

1. Keep the SHA-256, known version/options, and the original if you are allowed to share it.
2. Run `analyze`; record the report, never call an intermediate "full source".
3. Add a small fixture for the unsupported structure, never a hash lookup returning a static source.
4. Write positive, negative, over-budget, and related semantics tests.
5. Extend the correct module; do not open filesystem/network/Lua eval just to make a decoder run.
6. Check output against an independent oracle or a controlled test sandbox.
7. Publish the tried samples/profiles and limits, never upgrade them into a universal claim.

`research/legacy_sources` is legacy sample-specific research source. Never use it as a public-upload backend.
