# Research material

`rideafish/input.obfuscated.lua` is the one real source sample analyzed for this
request. `auto_recovered.lua` comes from the NEW static engine without a source
lookup/template. `manual_reference.lua` is the earlier manually simplified and
renamed reconstruction; the two are intentionally kept distinct.

`decoded.partial.lua` and `auto_graphs.json` are analysis intermediates, not extra
successful deobfuscations. The 74 mock scenarios concern ONE real sample only.

`regression/` is an opt-in LuaJIT mock test harness, never imported by the engine or
bot. `legacy_sources/` preserves the earlier sample-specific research programs;
these use different assumptions and optional Lua VM tooling. Do not use them as a
public upload backend. The production CLI entry point is `python -m moonveil`.

Third-party sample contents are not covered by the tooling MIT license. See
THIRD_PARTY_NOTICES.md before publishing them.
