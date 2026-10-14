# Archived sample-specific tooling

These are the original scripts used to inspect RideAFish, not the new general
profile engine and not a universal deobfuscator. They are included as requested
research source. They do NOT automatically produce the manually named reference.

Reproduction requires Node/npm and Lupa; work in a private disposable directory:
1. Copy `../rideafish/input.obfuscated.lua` to `RideAFish.obfuscated.lua` here.
2. Install the JS dependencies from package-lock.json (`npm ci` also needs Git
   because the historical formatter depends on a Git-hosted parser fork).
3. `node parse.js`
4. `python map_fields.py`
5. `python decode.py`
6. `node inspect.js`
7. `python unflatten.py` writes CFG/analysis, not a certified clean final source.

The current engine does not need these dependencies or use these hardcoded method
names/permutation constants. Do not execute archived VM-based tooling on arbitrary
uploads or deploy this directory inside a public bot worker.
