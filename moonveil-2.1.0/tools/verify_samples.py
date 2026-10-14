"""Independent LuaJIT checks for the two inspected, fixed-hash samples only.
No filesystem/network/Roblox APIs are provided to the Lua environment.
"""

from pathlib import Path
import hashlib, json, itertools
from lupa.luajit21 import LuaRuntime
import sys, argparse

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from moonveil21.extractor import parser_source

args = argparse.ArgumentParser(
    description="Execute only the two inspected fixture hashes in restricted LuaJIT; not a general sandbox"
)
args.add_argument("--trusted-fixtures", action="store_true")
opts = args.parse_args()
if not opts.trusted_fixtures:
    args.error("Review the fixtures and pass --trusted-fixtures to opt in.")
EXPECTED = {
    6: "0e34cd19184467821dbe6a744b7fa1ef71eb6200b19a754d2f0b5061caf0ad76",
    7: "fb26e52ce09f4faa5625b0c1b0a15a213af6ffd35ba2db5d570cbf08f6d3c172",
}
SETUP = r"""
jit.off()
local bit=require('bit')
local function unsigned(x) if x<0 then return x+4294967296 end return x end
local bits={}
for _,name in ipairs({'band','bor','bxor','bnot','lshift','rshift'}) do
 local f=bit[name]
 bits[name]=function(...) return unsigned(f(...)) end
end
bits.btest=function(...) return bit.band(...)~=0 end
local strings={}
for k,v in pairs(string) do strings[k]=v end
strings.unpack=function(format,bytes,position)
 position=position or 1
 local value,finish
 if format=='B' then value=string.byte(bytes,position);finish=position+1
 elseif format=='b' then value=string.byte(bytes,position);if value>=128 then value=value-256 end;finish=position+1
 elseif format=='>I2' then local a,b=string.byte(bytes,position,position+1);value=a*256+b;finish=position+2
 elseif string.match(format,'^c%d+$') then local n=tonumber(string.sub(format,2));value=string.sub(bytes,position,position+n-1);finish=position+n
 else error('Unreviewed unpack format '..format) end
 return value,finish
end
local tables={}
for k,v in pairs(table) do tables[k]=v end
tables.pack=function(...) return {n=select('#',...),...} end
tables.unpack=unpack
tables.create=function(n,value) local t={} if value~=nil then for i=1,n do t[i]=value end end return t end
tables.move=function(source,first,last,target,dest)
 dest=dest or source
 local values={}
 for i=first,last do values[i-first+1]=source[i] end
 for i=first,last do dest[target+i-first]=values[i-first+1] end
 return dest
end
local steps=0
debug.sethook(function() steps=steps+1;if steps>20000 then error('Instruction budget exceeded') end end,'',10000)
local function run(source,keys,reversePairs,poisonAssert,strictAssert)
 steps=0
 local report={checks={},iterator_inputs={},global_reads={},replacement_checks=0}
 local env,allowed={},{}
 local function check(condition,...)
  report.checks[#report.checks+1]={condition,...}
  if poisonAssert then
   env.assert=function(condition) report.replacement_checks=report.replacement_checks+1;return condition end
  end
  if strictAssert then assert(condition,...) end
  return condition,...
 end
 allowed.assert=check
 allowed.string=strings;allowed.table=tables;allowed.math=math;allowed.bit32=bits
 allowed.select=select;allowed.type=type;allowed.tonumber=tonumber;allowed.tostring=tostring
 allowed.unpack=unpack;allowed.pcall=pcall;allowed.error=error
 allowed.setmetatable=setmetatable;allowed.getmetatable=getmetatable;allowed.next=next
 allowed.rawget=rawget;allowed.rawset=rawset;allowed.rawequal=rawequal
 allowed.getfenv=function() return env end
 allowed._G=env
 allowed.ipairs=function(values)
  local input={}
  for i=1,#values do input[i]=values[i] end
  report.iterator_inputs[#report.iterator_inputs+1]=input
  if keys==nil then return ipairs(values) end
  local ordinal=0
  return function()
   ordinal=ordinal+1
   if ordinal>#keys then return nil end
   -- Deliberately distinguish keys from values to test what is captured.
   return keys[ordinal],9000+ordinal
  end,values,nil
 end
 allowed.pairs=function(values)
  local callbacks=true;local count=0
  for k,v in pairs(values) do count=count+1;if type(v)~='function' then callbacks=false end end
  if reversePairs and callbacks and count>0 then
   local index=#values+1
   return function()index=index-1;if index<1 then return nil end;return index,values[index]end,values,nil
  end
  return pairs(values)
 end
 setmetatable(env,{__index=function(_,key)
  if allowed[key]==nil then error('Blocked global '..tostring(key)) end
  if key=='assert' then report.global_reads[#report.global_reads+1]=key end
  return allowed[key]
 end})
 local fn,err=loadstring(source,'@reviewed-sample')
 assert(fn,err)
 setfenv(fn,env)
 local values=tables.pack(fn())
 report.return_count=values.n
 return report
end
return run
"""


def convert(v):
    if hasattr(v, "items"):
        keys = list(v.keys())
        if (
            keys
            and all(isinstance(k, int) for k in keys)
            and sorted(keys) == list(range(1, len(keys) + 1))
        ):
            return [convert(v[k]) for k in range(1, len(keys) + 1)]
        return {str(k): convert(val) for k, val in v.items()}
    return v


def execute(source, keys, reverse=False, poison=False, strict=False):
    lua = LuaRuntime(
        unpack_returned_tuples=True, register_eval=False, register_builtins=False
    )
    run = lua.execute(SETUP)
    return convert(
        run(
            source,
            None if keys is None else lua.table_from(keys),
            reverse,
            poison,
            strict,
        )
    )


cases = [None, [], [10], [2, 4, 6, 8, 10], [5, 4, 3, 2, 1], [-2, 0, 9], [1, 1, 1, 1, 1]]
results = []
for case in (6, 7):
    reference = ROOT / "samples" / f"sample_{case}.obfuscated.lua"
    raw = reference.read_bytes()
    assert hashlib.sha256(raw).hexdigest() == EXPECTED[case]
    original = parser_source(raw)[0].decode("ascii")
    recovered = (
        ROOT / "results" / f"sample_{case}" / "Moonveil_Deobfuscated.lua"
    ).read_text()
    for keys, reverse, poison in itertools.product(cases, (False, True), (False, True)):
        reference = execute(original, keys, reverse, poison, keys is None)
        actual = execute(recovered, keys, reverse, poison, keys is None)
        assert reference == actual, (case, keys, reverse, poison, reference, actual)
        results.append(
            {
                "sample": case,
                "keys": keys,
                "reverse_callback_order": reverse,
                "mutate_global_assert": poison,
                "passed": True,
            }
        )
    print("SAMPLE", case, "28 independent LuaJIT comparisons passed")
report = {
    "cases": results,
    "count": len(results),
    "runtime": "Lupa LuaJIT 2.1",
    "reference_payload_execution": "restricted pure Lua environment; fixed inspected input hashes only",
    "external_network": False,
    "filesystem_exposed_to_lua": False,
}
(ROOT / "validation" / "differential_56.json").write_text(json.dumps(report, indent=2))
print("TOTAL", len(results))
