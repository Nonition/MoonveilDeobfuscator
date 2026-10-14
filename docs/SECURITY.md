# Handling untrusted code

## Main engine

The engine reads the AST and evaluates a pure Lua subset in Python. No `eval`, `exec`, `loadstring`, `require`, `os.execute`, Roblox APIs, HTTP, or Lua VM is granted to the input. `getfenv()` in the evaluator only returns a marker; accessing the marker to read the environment is denied. Node only runs the vendored parser.

Even so, the parser and transformers still process adversarial data. Do not treat Python limits or the "static" property as an audited sandbox. Parser bugs, CPU/memory exhaustion, or output bloat may remain.

## Default limits

- CLI: 2 MiB input; parser subprocess heap 192 MiB/time limit; 50 million pure-evaluator steps; 120-second evaluator.
- Evaluator: call-depth limits, table allocation, string size; no global writes.
- CFG: state/nesting/emission limits. Max 2 MiB output source.
- Discord example: 512 KiB input, one worker/job at a time, 20-second cooldown; 45-second / 30-million-step evaluator; 110-second process timeout; 8 MiB max result.
- Some steps outside the evaluator may use extra time/memory. OS limits are required for a public service.

## Production recommendations

- Dedicated worker with an unprivileged UID, disabled network, read-only root filesystem, resource quotas, timeouts, and a per-job temp directory.
- Do not mount private repositories, home, the Docker socket, or credentials into the worker container.
- The bot keeps tokens in the bot process environment; the adapter filters the environment before invoking the worker. Never place tokens into Lua, AI prompts, public config files, or archives.
- If the bot uses the Docker daemon, only the admin bot invokes the fixed Docker command; users must not select image/mount/flags.
- Accept no arbitrary URLs. Never auto-extract user archives. Never use attachment names as executed path/shell arguments.
- Never execute output, test harnesses, or a Lua VM on public uploads.
- Never retain source/logs longer than needed. The example uses temp directories and never logs source content.
- Monitor frequency, size, user permissions, and worker errors; the example is no substitute for production monitoring/queues.

## Optional regression is fully separate from the engine

`research/regression` uses LuaJIT via Lupa to run the known sample inside API mocks. The reference SHA-256 is pinned. This is a local functional test, not a security isolation boundary and not the Discord bot path. Only opt in for reviewed sources; preferably also run it in a network/secret-free container.

Embedded URLs/remotes in the sample are never contacted when running mocks. Running the resulting Lua file in a real Roblox environment may produce the actions that source describes; the tool does not verify game rights, state, or endpoint trustworthiness.

## Bugs and disclosure

When reporting a bug, provide the privacy-scrubbed report, input hash, and a minimal reproducer if permitted. No Discord/GitHub token or credential is needed to debug a pure decoder.
