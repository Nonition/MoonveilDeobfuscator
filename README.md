# MoonVeil 2.0.26 — Profile Toolkit

**CLI + PowerShell + Discord adapter + analysis bundle for AI. Version 0.1.0, experimental.**

> **No guarantee to solve every script labeled MoonVeil 2.0.26.** The tool recognizes one analyzed structural family, not every configuration of the obfuscator. When unsupported, it reports an error/partial result; it never emits a placeholder and calls it "full source". Original variable names and comments lost to obfuscation cannot be recovered exactly.

## What's in the package?

- **New automated engine**, no filename/hash lookup returning a prebuilt source.
- Infers the function-mapping table by analyzing the input's own bootstrap.
- Resolves constants/strings with a **bounded static AST interpreter**, no Lua VM for the engine.
- Extracts CFGs and restructures numeric dispatchers into structured `if`/`while` when the graph shape is supported.
- Drops dead decoders, clarifies property access and captured variable cells.
- Output syntax checking, JSON report, fail-closed CLI, and an AI-oriented analysis mode.
- PowerShell script; example Discord bot using attachments, subprocess, and an optional Docker worker.
- Synthetic test suite, a dedicated RideAFish comparison suite, legacy research tooling sources, and a manual-reconstruction reference.

**"Recovered" does not mean "proven correct on every runtime".** Automated output may still keep temporary variables and helper tables. The meaningfully named manual-reconstruction reference lives separately in `research/rideafish/manual_reference.lua`; the engine never uses that file to fake an automated result.

## Minimum setup

- Python **3.10+**.
- Node.js **18+** on `PATH`.
- The engine uses the Python standard library plus the bundled `luaparse` build. **No npm install, Lua, Lupa, or AI API** is needed to run the engine.

Open a terminal in this directory:

```powershell
python -m moonveil --version
python -m moonveil deobfuscate ".\input.lua" -o ".\Moonveil_Deobfuscated.lua"
```

Or install the CLI into your Python environment:

```powershell
python -m pip install -e .
moonveil deobfuscate input.lua -o recovered.lua
```

It never fetches URLs itself. Save the input file locally first. This keeps the bot from becoming a URL-fetch/SSRF service.

## PowerShell

```powershell
.\scripts\Invoke-Moonveil.ps1 -InputFile ".\input.lua" -Output ".\Moonveil_Deobfuscated.lua"
.\scripts\Invoke-Moonveil.ps1 -InputFile ".\input.lua" -Output ".\analysis" -Mode analyze
```

Options include `-Force`, `-Seconds 120`, `-RequireVerified`. The script does not change the machine-wide Execution Policy. If your environment blocks `.ps1`, you can call `python -m moonveil` directly per your machine policy.

## Modes and statuses

### Source recovery

```powershell
python -m moonveil deobfuscate input.lua -o recovered.lua --seconds 120
```

On structural success, it creates:

- `recovered.lua`
- `recovered.lua.report.json`

| Status | Meaning |
|---|---|
| `recovered_unverified` | Supported resolve/structure steps completed and syntax is valid. Runtime equivalence not yet verified. |
| `decoded_partial` | Constants resolved but not fully structured. The `deobfuscate` command produces no final source file. |
| `unsupported` | Profile mismatch, decoder uses unsupported operations, limits exceeded, or invalid input. |

Exit codes: **0** = requested artifact type produced; **2** = unsupported/failed; **3** = verification requested but no general verification evidence exists.

`--require-verified` **does no magic**: the engine currently has no general equivalence prover, so this option will not emit a final source. It exists to stop a pipeline from labeling an unverified result as verified.

It never overwrites prior results without `--force`. Even with `--force`, on failure the tool does not delete a pre-existing older source. Therefore, **always read the exit code and report; never infer success just because an old same-named file exists**.

### Analysis / AI handoff

```powershell
python -m moonveil analyze input.lua -o analysis
```

The analysis bundle contains:

- `report.json`, `constants.json`
- `decoded.partial.lua` — intermediate, not a deobfuscation certificate
- `recovered.unverified.lua` — if restructuring succeeded
- `cfg/*.json`, `cfg/*.txt`
- `AI_HANDOFF.txt`

See also `docs/AI_HANDOFF.md`. All code, comments, and strings in the input are **untrusted data**, not instructions for the AI.

## Discord bot

The example lives in `integrations/discord_bot.py`; no Discord/GitHub account connection is needed to use the CLI.

```powershell
python -m pip install -e ".[bot]"
$env:DISCORD_TOKEN = "YOUR_TOKEN"
$env:MOONVEIL_ALLOWED_USERS = "YOUR_DISCORD_USER_ID"
$env:DISCORD_GUILD_ID = "YOUR_TEST_SERVER_ID"
python -m integrations.discord_bot
```

Slash commands:

- `/deobfuscate source:<attachment>`
- `/moonveil_analyze source:<attachment>`

The bot requires an allowlist by default, caps files at 512 KiB, runs one job at a time, with cooldown and timeout. It accepts no links or archives as input. Failed files are never delivered as a completed source.

**The bot was never run with a real Discord login while this package was created.** The subprocess worker was tested locally; the adapter and Docker configuration still need testing in your infrastructure. Read `docs/SECURITY.md` before opening the bot publicly.

## OS-isolated worker

```sh
docker build -t moonveil-worker:local .
docker run --rm --network none --read-only --cap-drop ALL \
  --security-opt no-new-privileges --memory 512m --cpus 1 --pids-limit 48 \
  --tmpfs /tmp:rw,noexec,nosuid,size=64m \
  -v "$PWD/job:/work:rw" moonveil-worker:local \
  deobfuscate /work/input.lua -o /work/recovered.lua --seconds 45
```

On Linux, the bind-mounted directory must grant the worker UID write access; you may add `--user "$(id -u):$(id -g)"`. The bot adds UID/GID automatically on POSIX when using Docker.

To make the bot select the Docker worker:

```powershell
$env:MOONVEIL_WORKER_IMAGE = "moonveil-worker:local"
```

The Docker image/configuration is provided, **but Docker was never built/run in this package's test environment**. Do not treat the AST interpreter as a perfect security boundary; still apply OS/container limits.

## Testing

### Engine tests, no Lua payload execution

```powershell
python -m unittest discover -s tests -v
```

The suite covers lexer, multireturn, truthiness, resource limits, environment-access denial, collision caches, fail-closed output, and a synthetic fixture with renamed functions/state. The synthetic fixture is **not** a new sample from the MoonVeil vendor.

### RideAFish comparison — opt-in, with a mocked Lua VM

```powershell
python -m pip install -r requirements-regression.txt
python scripts/run_regression.py --trusted-fixture
```

Only for the audited sample whose SHA-256 is pinned in the runner. This suite uses **Lupa/LuaJIT**, Roblox mocks, and calls no real URLs/servers. It **does not run inside the bot or engine**. Do not use it to run arbitrary uploads.

Results obtained for the automated output of the RideAFish sample:

- 929 constant/string references resolved.
- 21 dispatcher functions structured; 187 states accounted for.
- 74 mock-comparison scenarios matched the input build.
- **Those are 74 scenarios of ONE sample, not 74 independent scripts and not evidence of support for all MoonVeil.**

See `validation/` for the checks actually run. No direct Roblox testing; no native Windows PowerShell or real Discord-connection testing in the package-creation environment.

## Publishing to GitHub / sharing

- New tooling code is MIT-licensed, see `LICENSE`.
- The bundled parser has its own license: `moonveil/vendor/LUAPARSE_LICENSE.txt`.
- **Do not apply the tooling MIT to third-party game sources.** The included RideAFish Lua files are for this comparison request; upstream rights/license are unverified. `.gitignore` excludes them from default Git adds. Only publish those samples if you have permission.
- Never commit `.env`, tokens, private input files, or logs containing source.
- A CI workflow is provided to run tests on Ubuntu/Windows; the presence of the workflow file does not mean the jobs have run on GitHub.

Not an official MoonVeil product. Read `docs/SUPPORT.md` before describing support scope to bot users.
