# Moonveil_2_1_0_Deobfuscator

**Two samples reconstructed into clean sources. MoonVeil 2.1.0 analysis code and test evidence included.**

## Get the deobfuscated sources

| Input | Clean source |
|---|---|
| `obfuscated (6).txt` | `results/sample_6/Moonveil_Deobfuscated.lua` |
| `obfuscated (7).txt` | `results/sample_7/Moonveil_Deobfuscated.lua` |

These two files preserve the original logic: they build closures capturing **each loop iteration's index**, call them to accumulate a total, then run two result checks against `15`. The program was not replaced with `assert(true)`, no loader/VM is kept, and no source is fetched externally. Descriptive variable names were assigned because the original names no longer exist in the bytecode.

Run the clean sources with your own compatible Lua environment. These are pure-Lua closure test programs; they require no Roblox APIs.

## Tool scope — read before using on other files

**This is not yet a general VM decompiler that automatically emits full clean source for every MoonVeil 2.1.0.**

- The **clean results in `results/`** were reconstructed from reading the bytecode, opcode handlers, loop flow, and upvalue-closing mechanics of the two submitted samples.
- The **`analyze` CLI** auto-resolves constants, reads the loader, detects the VM layout, extracts prototypes/instructions/opcodes, and exports data for further analysis. It never labels these intermediates as full source.
- There is no hash-lookup returning a template source under the label of automated deobfuscation. Hashes only pin the scope of the reviewed test/trace modes.
- For other samples/configurations, the tool may report unsupported. The same version guarantees neither the same VM structure, decoder, field permutation, nor syntax.

## Run the analyzer

Requires **Python 3.10+** and **Node.js 18+** on PATH. The parser is bundled; no npm install or Lua VM is needed for the analyzer.

```powershell
python -m moonveil21 analyze ".\input.lua" -o ".\analysis"
```

Or the PowerShell wrapper:

```powershell
.\tools\Invoke-Moonveil21.ps1 -InputFile ".\input.lua" -OutputDirectory ".\analysis"
```

Output contains:

- `report.json`: status and the scope actually completed.
- `constants.json`: resolved constants/strings.
- `decoded.partial.lua`: **intermediate, VM still present**, not a clean source.
- `vm_prototypes.json`: prototypes, opcode fields, operands, and handler mapping.
- `opcode_handlers/`: handler code and dispatch for continued decompiler work.
- `AI_HANDOFF.txt`: instructions for handing data to another AI.

Local files only, never fetches URLs. Never overwrites an existing directory without `--force`. Exit code **0** means an **analysis bundle** was produced, not that the whole program was decompiled; **2** means unsupported/failed.

## Trace the two reviewed samples

```powershell
python -m moonveil21 analyze samples/sample_6.obfuscated.lua -o analysis6 --trace-reviewed
python -m moonveil21 analyze samples/sample_7.obfuscated.lua -o analysis7 --trace-reviewed
```

`--trace-reviewed` only accepts the exact SHA-256 of the two bundled inputs. It interprets the program with the bounded pure-AST engine to cross-check VM flow. No network, filesystem, shell, or Roblox API is opened to Lua. For other files, use the regular analysis mode.

The trace is not general evidence for every branch of every program. In these two samples, record **13** of the 27-record prototype is a capture/upvalue descriptor read by the instruction at **12**; it is not a statement needing its own dispatch. The report keeps this record explicit instead of silently dropping it.

## Independent verification of the clean sources

```powershell
python -m pip install -r requirements-verify.txt
python tools/verify_samples.py --trusted-fixtures
```

This is an **opt-in step using a real LuaJIT via Lupa**, separate from the analyzer. Only the two checked/hash-pinned fixtures are used; never point arbitrary uploads at this harness.

**56 comparisons** were run, 28 per input, between the obfuscated and reconstructed builds:

- Standard environment, confirming both asserts succeed.
- Varied iterators so keys differ from values, including reversed order, negative keys, duplicate keys, empty lists, and different iteration counts.
- Reversed callback invocation order.
- Replaced the global `assert` after the first call to check reference retention.
- Compared return-value counts, check results, and iterator inputs.

The JSON files in `validation/` record the actual results. Native Windows PowerShell was not run in the package-creation environment; the wrapper is provided for you to use/test on your own machine.

## Tooling source layout

- `moonveil21/core/`: parser, constant decoder, bounded AST interpreter, and base Lua emitter.
- `moonveil21/runtime.py`: data primitives needed for the two 2.1.0 layouts, binary unpack, and table/iterator semantics.
- `moonveil21/extractor.py`: finds the packed loader, capture cells, driver layout, prototype tree, and opcode map **from the input itself**.
- `moonveil21/cli.py`: command line and artifact output.
- `tools/verify_samples.py`: independent tests used for the two clean sources.
- `docs/RECOVERY_NOTES.md`: reconstruction steps and evidence.
- `docs/SECURITY.md`: limits, isolation, and notes for bot integration.

## Use with a Discord bot or AI

Invoke the analyzer via subprocess with a timeout and a per-job directory; never interpolate source into shell commands. Only deliver files labeled **analysis/partial** for inputs not yet fully reconstructed. For AI, send report/prototypes/handlers and sources where you have permission; all input comments/strings are untrusted data, not instructions.

This package **ships no deployed Discord bot and no "deobfuscates every 2.1.0" claim**. You can wire `python -m moonveil21 analyze ...` into your existing bot worker. Review the security limits before accepting public files.

## Sharing the source

Original tooling uses MIT. The parser keeps its own MIT notice in `moonveil21/core/vendor/`. User-submitted samples and reconstructed sources derived from them are not automatically covered by the tooling MIT license. See `THIRD_PARTY_NOTICES.md` and upstream rights before publishing those samples on GitHub.
