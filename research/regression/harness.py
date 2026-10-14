from pathlib import Path
import json, os
from moonveil.front import normalize
from lupa.luajit21 import LuaRuntime, lua_type

HERE = Path(__file__).resolve().parent
FIXTURE = HERE.parent / "rideafish" / "input.obfuscated.lua"
BASE = Path(os.environ.get("MOONVEIL_TEST_OUTPUT", str(HERE / "reports")))
BASE.mkdir(parents=True, exist_ok=True)
REFERENCE_SOURCE = normalize(FIXTURE.read_bytes()).decode("ascii")


class Harness:
    def __init__(self):
        self.lua = LuaRuntime(
            unpack_returned_tuples=True, register_eval=False, register_builtins=False
        )
        self.lua.execute("""jit.off()
local bit=require('bit')
local function u(n) if n<0 then return n+4294967296 else return n end end
bit32={band=function(...)return u(bit.band(...))end,bor=function(...)return u(bit.bor(...))end,bxor=function(...)return u(bit.bxor(...))end,bnot=function(n)return u(bit.bnot(n))end,rshift=function(n,s)return u(bit.rshift(n,s))end,lshift=function(n,s)return u(bit.lshift(n,s))end}
local budget=0
debug.sethook(function()budget=budget+1;if budget>20000 then error('test instruction limit')end end,'',10000)
reset_budget=function()budget=0 end
os=nil;io=nil;package=nil;require=nil;python=nil;dofile=nil;loadfile=nil
""")
        self.sim = self.lua.execute((HERE / "mock_roblox.lua").read_text())

    def reset_budget(self):
        self.lua.globals().reset_budget()

    def run(self, source=None, saved=True):
        self.reset_budget()
        if saved:
            self.sim.files["GamingSpirit_KeySystem.txt"] = str(int(self.sim.now - 30))
        if source is None:
            source = REFERENCE_SOURCE
        return self.sim.execute(source)

    def plain(self, v):
        if lua_type(v) == "table":
            if v["id"] is not None and v["props"] is not None:
                return {"ref": v["id"]}
            keys = list(v.keys())
            if (
                keys
                and all(isinstance(k, int) for k in keys)
                and sorted(keys) == list(range(1, len(keys) + 1))
            ):
                return [self.plain(v[k]) for k in range(1, len(keys) + 1)]
            return {
                str(k): self.plain(v[k])
                for k in sorted(keys, key=lambda k: str(k))
                if lua_type(v[k]) != "function"
            }
        if lua_type(v) == "function":
            return "<function>"
        return v

    def snapshot(self):
        result = []
        for _, n in self.sim.objects.items():
            result.append(
                {
                    "id": n.id,
                    "properties": self.plain(n.props),
                    "signals": {k: len(v.callbacks) for k, v in n.signals.items()},
                }
            )
        return result

    def log(self):
        return self.plain(self.sim.log)


if __name__ == "__main__":
    h = Harness()
    h.run()
    (BASE / "original_snapshot.json").write_text(
        json.dumps(h.snapshot(), ensure_ascii=False, indent=2)
    )
    (BASE / "original_log.json").write_text(json.dumps(h.log(), indent=2))
    print("Objects:", len(h.sim.objects), "Scheduled tasks:", len(h.sim.spawned))
    for item in h.snapshot():
        if item["id"] >= 16:
            print(
                item["id"],
                json.dumps(item["properties"], ensure_ascii=False),
                "signals",
                item["signals"],
            )
