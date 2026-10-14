# Reconstruction evidence for the two 2.1.0 inputs

## Identification

- Sample 6: 125,381 bytes; SHA-256 `0e34cd19184467821dbe6a744b7fa1ef71eb6200b19a754d2f0b5061caf0ad76`.
- Sample 7: 98,341 bytes; SHA-256 `fb26e52ce09f4faa5625b0c1b0a15a213af6ffd35ba2db5d570cbf08f6d3c172`.
- Both carry the MoonVeil **2.1.0** header, not 2.0.26.
- Each sample has one `K+=1` counter; only this local-addition assignment was lowered to `K=K+1` so the Lua parser can read it. Strings/comments were not rewritten by reckless numeric regexes.

## Outer layer

The analyzer reads the bootstrap and export table without guessing functions from filenames. Numeric/MBA constants and string caches are computed with the bounded AST engine:

| Sample | Constant references resolved |
|---|---:|
| 6 | 838 |
| 7 | 644 |

The loaders still contain base85/compressed bytecode. Resolving outer-layer constants alone is **not enough** to call it a complete deobfuscation.

## VM layer

| Sample | Loader inside input | Prototypes | Instruction records |
|---|---|---:|---:|
| 6 | `k` | 3 | 12 + 27 + 1 = 40 |
| 7 | `m` | 2 | 27 + 1 = 28 |

The layout comes from the driver AST. The two samples permute both the opcode fields and the handler-call argument order differently:

- Sample 6: opcode field 17; handler args carry instruction/frame/registers at positions 1/4/3 (zero-based).
- Sample 7: opcode field 26; the corresponding positions are 0/2/5.

A runtime frame may share the instruction list with the prototype descriptor. The extractor distinguishes pure-data descriptors from frames holding function helpers; it does not blindly pick the first table-looking capture.

Instruction literals and caches may change while the VM runs. The trace pins the code-table identity after first recognition instead of repeatedly re-fingerprinting the mutated data.

## Reconstructed logic

The 27-record prototype:

1. Creates a table holding callbacks.
2. Creates `{1, 2, 3, 4, 5}` and takes the `ipairs` iterator.
3. Takes only the iterator's **first return value** as the loop variable — this is the index, not the element value.
4. Creates a closure capturing the current iteration's index; appends the closure to the end of the callback table.
5. Closes the upvalue before moving to the next iteration.
6. Uses `pairs` to walk the callbacks, calls each, and sums the totals.
7. Returns the total.

The single-record prototype returns the captured upvalue. Record 13 in the parent prototype is a descriptor consumed by the closure-creating instruction at record 12; so the trace does not dispatch record 13 separately.

Sample 6 wraps even the outer check in the VM; sample 7 leaves the outer check as flattened Lua. Both still carry an equivalent non-VM form of the logic. The check keeps one `assert` reference, then calls two functions, comparing each result against `15`.

The clean source keeps two independent functions and two checks instead of optimizing the whole program into a constant `true`. Using `local capturedIndex = index` makes explicit the per-iteration binding that the VM implements via close-upvalue mechanics.

## Verification

- The pure-AST trace confirms both checks hold in the standard environment.
- All reachable statement records are checked; the capture descriptor is reviewed separately.
- Independent LuaJIT tests compare original vs. recovered across 28 configurations per file, 56 total.
- Iterator configurations with keys differing from values catch "capture value" style mis-reconstructions or constant-`15` shortcuts.
- Mutating the global `assert` after the first call checks reference caching.

These tests are evidence for the two specific inputs, not proof of a universal decompiler. Original identifiers/comments are not restored verbatim; the sources use new descriptive names.
