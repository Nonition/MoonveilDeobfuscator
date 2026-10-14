from pathlib import Path
import json
from lupa.luajit21 import LuaRuntime

BASE=Path(__file__).resolve().parent
src=(BASE/'normalized.lua').read_text()
ast=json.loads((BASE/'ast.json').read_text())
fields=json.loads((BASE/'mapped_fields.json').read_text())
lua=LuaRuntime(encoding=None,unpack_returned_tuples=True,register_eval=False,register_builtins=False)
lua.execute(b'''jit.off()
local bit=require('bit')
local function u(n) if n<0 then return n+4294967296 else return n end end
bit32={
 band=function(...) return u(bit.band(...)) end,
 bor=function(...) return u(bit.bor(...)) end,
 bxor=function(...) return u(bit.bxor(...)) end,
 bnot=function(n) return u(bit.bnot(n)) end,
 rshift=function(n,s) return u(bit.rshift(n,s)) end,
 lshift=function(n,s) return u(bit.lshift(n,s)) end
}
local budget=0
debug.sethook(function() budget=budget+1; if budget>20000 then error('decoder instruction limit') end end,'',10000)
reset_budget=function() budget=0 end
os=nil; io=nil; require=nil; package=nil; python=nil; dofile=nil; loadfile=nil
''')
ctx=lua.table()
allow={'a','b','c','d','P','Q','R','S','T','U','V','h','i','pa','qa','sa','ta','ja','ka','la','ma','ra','oa','va','wa'}
for f in fields:
 if f['name'] in allow:
  lo,hi=f['range']
  ctx[f['name'].encode()]=lua.eval(src[lo:hi].encode())
for k in ['ia','na','ua']: ctx[k.encode()]=lua.table()
for name in ('P','R','T'): ctx[name.encode()]=ctx[name.encode()](ctx)

def literal(value):
 if value is None: return 'nil'
 if isinstance(value,bool): return 'true' if value else 'false'
 if isinstance(value,(int,float)):
  return str(int(value)) if int(value)==value else repr(value)
 if isinstance(value,bytes):
  out='"'
  for b in value:
   if b==34: out+='\\"'
   elif b==92: out+='\\\\'
   elif b==10: out+='\\n'
   elif b==13: out+='\\r'
   elif b==9: out+='\\t'
   elif b<32 or b>126: out+='\\'+str(b).zfill(3)
   else: out+=chr(b)
  return out+'"'
 raise TypeError(type(value))

replacements=[]
records=[]

def walk(node):
 if isinstance(node,list):
  for x in node: walk(x)
 elif isinstance(node,dict):
  if node.get('type')=='LogicalExpression' and node.get('operator')=='or':
   left=node['left']; right=node['right']
   if left.get('type')=='IndexExpression' and left['base'].get('type')=='MemberExpression' and left['base']['identifier']['name'] in ('ia','na','ua'):
    assert right['type']=='CallExpression'
    method=right['base']['identifier']['name']
    assert method in allow,method
    receiver=right['base']['base']['name']
    expr=src[slice(*right['range'])]
    lua.globals()[b'reset_budget']()
    value=lua.eval(('function('+receiver+') return '+expr+' end').encode())(ctx)
    text=literal(value)
    replacements.append((*node['range'],'('+text+')'))
    records.append({'range':node['range'],'method':method,'cache':left['base']['identifier']['name'],'index_source':src[slice(*left['index']['range'])],'source':src[slice(*node['range'])],'decoded':text})
    return
  for k,v in node.items():
   if k not in ('range','globals','comments','loc'): walk(v)
walk(ast)
for lo,hi,text in sorted(replacements,reverse=True): src=src[:lo]+text+src[hi:]
(BASE/'decoded.lua').write_text(src)
(BASE/'constants.json').write_text(json.dumps(records,indent=2))
print('Decoded references:',len(records))
strings=sorted({r['decoded'] for r in records if r['decoded'].startswith('"')})
print('Unique strings:',len(strings))
print('\n'.join(strings))
