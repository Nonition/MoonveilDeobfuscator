from pathlib import Path
import json, copy, math
BASE=Path(__file__).resolve().parent
ast=json.loads((BASE/'decoded_ast.json').read_text())
fields=json.loads((BASE/'mapped_fields.json').read_text())

def num(v): return {'type':'NumericLiteral','value':int(v) if int(v)==v else v,'raw':str(v)}
def truth(v): return v is not False and v is not None
UNKNOWN=object()
def eval_const(x,env={}):
 if not isinstance(x,dict): return UNKNOWN
 t=x.get('type')
 if t in ('NumericLiteral','StringLiteral','BooleanLiteral','NilLiteral'): return x.get('value')
 if t=='Identifier': return env.get(x['name'],UNKNOWN)
 if t=='UnaryExpression':
  v=eval_const(x['argument'],env)
  if v is UNKNOWN:return UNKNOWN
  if x['operator']=='-':return -v
  if x['operator']=='not':return not truth(v)
  if x['operator']=='#' and isinstance(v,str): return len(v)
 if t in ('BinaryExpression','LogicalExpression'):
  a,b=eval_const(x['left'],env),eval_const(x['right'],env); op=x['operator']
  if op=='and' and a is not UNKNOWN: return b if truth(a) else a
  if op=='or' and a is not UNKNOWN: return a if truth(a) else b
  if a is UNKNOWN or b is UNKNOWN:return UNKNOWN
  if op=='+':return a+b
  if op=='-':return a-b
  if op=='*':return a*b
  if op=='/':return a/b
  if op=='%':return a%b
  if op=='^':return a**b
  if op=='==':return a==b
  if op=='~=':return a!=b
  if op=='>':return a>b
  if op=='<':return a<b
  if op=='>=':return a>=b
  if op=='<=':return a<=b
 return UNKNOWN

def simpl(x,env):
 if isinstance(x,list):return [simpl(v,env) for v in x]
 if not isinstance(x,dict):return x
 if x.get('type')=='FunctionDeclaration':return copy.deepcopy(x)
 if x.get('type')=='Identifier' and x['name'] in env:return num(env[x['name']])
 y={k:(copy.deepcopy(v) if (k=='identifier' and x.get('type')=='MemberExpression') or (k=='key' and x.get('type')=='TableKeyString') else simpl(v,env)) for k,v in x.items() if k not in ('range','loc')}
 if y.get('type') in ('BinaryExpression','UnaryExpression','LogicalExpression'):
  v=eval_const(y)
  if v is not UNKNOWN:
   if isinstance(v,bool):return {'type':'BooleanLiteral','value':v,'raw':str(v).lower()}
   if isinstance(v,(int,float)):return num(v)
 return y

def expr(x):
 t=x['type']
 if t=='Identifier':return x['name']
 if t=='NumericLiteral':return str(int(x['value'])) if x['value']==int(x['value']) else repr(x['value'])
 if t=='StringLiteral':return x.get('raw') or json.dumps(x['value'],ensure_ascii=False)
 if t=='BooleanLiteral':return 'true' if x['value'] else 'false'
 if t=='NilLiteral':return 'nil'
 if t=='VarargLiteral':return '...'
 if t=='MemberExpression':return expr(x['base'])+x['indexer']+x['identifier']['name']
 if t=='IndexExpression':return expr(x['base'])+'['+expr(x['index'])+']'
 if t=='UnaryExpression':return '('+x['operator']+' '+expr(x['argument'])+')'
 if t in ('BinaryExpression','LogicalExpression'):return '('+expr(x['left'])+' '+x['operator']+' '+expr(x['right'])+')'
 if t=='CallExpression':return expr(x['base'])+'('+', '.join(expr(a) for a in x['arguments'])+')'
 if t=='TableCallExpression':return expr(x['base'])+'('+expr(x['arguments'])+')'
 if t=='StringCallExpression':return expr(x['base'])+'('+expr(x['argument'])+')'
 if t=='TableConstructorExpression':
  fs=[]
  for f in x['fields']:
   if f['type']=='TableValue':fs.append(expr(f['value']))
   elif f['type']=='TableKeyString':fs.append(f['key']['name']+' = '+expr(f['value']))
   else:fs.append('['+expr(f['key'])+'] = '+expr(f['value']))
  return '{'+', '.join(fs)+'}'
 if t=='FunctionDeclaration':return 'function('+', '.join(expr(p) for p in x['parameters'])+')\n'+block(x['body'],1)+'\nend'
 raise ValueError(t)

def statement(s,level=0):
 pad='    '*level;t=s['type']
 if t in ('AssignmentStatement','LocalStatement'):
  return pad+('local ' if t=='LocalStatement' else '')+', '.join(expr(v) for v in s['variables'])+(' = '+', '.join(expr(v) for v in s['init']) if s['init'] else '')
 if t=='ReturnStatement':return pad+'return '+', '.join(expr(v) for v in s['arguments'])
 if t=='CallStatement':return pad+expr(s['expression'])
 if t=='BreakStatement':return pad+'break'
 if t=='IfStatement':
  out=[]
  for idx,c in enumerate(s['clauses']):
   out.append(pad+('if '+expr(c['condition'])+' then' if idx==0 else 'elseif '+expr(c['condition'])+' then' if 'condition' in c else 'else'))
   out.append(block(c['body'],level+1))
  out.append(pad+'end');return '\n'.join(out)
 if t=='WhileStatement':return pad+'while '+expr(s['condition'])+' do\n'+block(s['body'],level+1)+'\n'+pad+'end'
 if t=='RepeatStatement':return pad+'repeat\n'+block(s['body'],level+1)+'\n'+pad+'until '+expr(s['condition'])
 if t=='FunctionDeclaration':return pad+('local ' if s.get('isLocal') else '')+'function '+expr(s['identifier'])+'('+', '.join(expr(p) for p in s['parameters'])+')\n'+block(s['body'],level+1)+'\n'+pad+'end'
 if t=='ForNumericStatement':return pad+'for '+expr(s['variable'])+' = '+expr(s['start'])+', '+expr(s['end'])+(', '+expr(s['step']) if s.get('step') else '')+' do\n'+block(s['body'],level+1)+'\n'+pad+'end'
 if t=='ForGenericStatement':return pad+'for '+', '.join(expr(v) for v in s['variables'])+' in '+', '.join(expr(v) for v in s['iterators'])+' do\n'+block(s['body'],level+1)+'\n'+pad+'end'
 if t=='DoStatement':return pad+'do\n'+block(s['body'],level+1)+'\n'+pad+'end'
 raise ValueError(t)
def block(ss,level=0):return '\n'.join(statement(s,level) for s in ss)

def select(ss,statevar,state):
 selected=[]
 for s in ss:
  if s['type']=='IfStatement':
   for c in s['clauses']:
    v=eval_const(c['condition'],{statevar:state}) if 'condition' in c else True
    if v is UNKNOWN: raise ValueError('not a dispatcher: '+expr(c['condition']))
    if truth(v):
     selected.extend(select(c['body'],statevar,state));break
  else:selected.append(s)
 return selected

def branch(x):
 val=eval_const(x)
 if val is not UNKNOWN:
  assert isinstance(val,(int,float)) and not isinstance(val,bool),(val,x)
  assert abs(val-round(val))<1e-8,(val,x)
  return {'goto':int(round(val))}
 if x['type']=='LogicalExpression' and x['operator']=='or' and x['left']['type']=='LogicalExpression' and x['left']['operator']=='and':
  return {'cond':x['left']['left'],'yes':branch(x['left']['right']),'no':branch(x['right'])}
 raise ValueError('Unhandled branch '+expr(x))

def leaves(t):
 if 'goto' in t:return {t['goto']}
 if 'cond' in t:return leaves(t['yes'])|leaves(t['no'])
 return set()

def build_graph(fn):
 loops=[(i,s) for i,s in enumerate(fn['body']) if s['type'] in ('WhileStatement','RepeatStatement')]
 if not loops:return None
 assert len(loops)==1
 li,loop=loops[0]
 test=loop['body'][0]['clauses'][0]['condition']
 assert test['type']=='BinaryExpression'
 var=test['left']['name']
 initial=None;prefix=[]
 for s in fn['body'][:li]:
  if s['type']=='LocalStatement':
   q=copy.deepcopy(s);q['variables']=[v for v in q['variables'] if v.get('name')!=var]
   prefix.append(q)
  elif s['type']=='AssignmentStatement' and any(v.get('name')==var for v in s['variables']):
   q=copy.deepcopy(s)
   vs=[];vsinit=[]
   for k,v in enumerate(q['variables']):
    if v.get('name')==var:initial=eval_const(q['init'][k])
    else:vs.append(v);vsinit.append(q['init'][k])
   if vs:q['variables']=vs;q['init']=vsinit;prefix.append(q)
  else:prefix.append(s)
 assert isinstance(initial,(float,int)),(initial,var)
 nodes={};todo=[initial]
 while todo:
  state=todo.pop()
  if state in nodes:continue
  if len(nodes)>1000:raise ValueError('too many states')
  body=select(loop['body'],var,state)
  current=num(state);stmts=[];term=None
  for s in body:
   if s['type']=='AssignmentStatement':
    rhs=simpl(s['init'],{var:eval_const(current)}) if eval_const(current) is not UNKNOWN else copy.deepcopy(s['init'])
    vs=[];ins=[]
    for j,v in enumerate(s['variables']):
     if v.get('type')=='Identifier' and v['name']==var:
      current=rhs[j]
     else:
      vs.append(v)
      if j<len(rhs):ins.append(rhs[j])
    if vs:stmts.append({'type':'AssignmentStatement','variables':vs,'init':ins})
   else:
    stmts.append(s)
    if s['type']=='ReturnStatement':term={'return':True}
  if term is None:term=branch(current)
  nodes[state]={'stmts':stmts,'term':term}
  todo.extend(leaves(term)-nodes.keys())
 return {'var':var,'start':initial,'prefix':prefix,'nodes':nodes,'suffix':fn['body'][li+1:]}

if __name__=='__main__':
 table=ast['body'][0]['arguments'][0]['base']['base']
 skip={'O','P','Q','R','S','T','U','V','h','i','g','xa','pa','qa','sa','ta','ja','ka','la','ma','ra','oa','va','wa','a','b','c','d','_','ia','na','ua'}
 result={}
 (BASE/'cfg').mkdir(exist_ok=True)
 for f,m in zip(table['fields'],fields):
  name=m['name']
  if name in skip:continue
  fac=f['value']; fn=fac['body'][0]['arguments'][0]
  graph=build_graph(fn)
  result[name]={'self':fac['parameters'][0]['name'],'capture':fac['parameters'][1]['name'] if len(fac['parameters'])>1 else None,'fn':fn,'graph':graph}
  if graph:
   lines=['-- '+name+' start='+str(graph['start'])+' state='+graph['var'],block(graph['prefix'])]
   for st,n in sorted(graph['nodes'].items()):
    lines.append('\n-- STATE '+str(st))
    lines.append(block(n['stmts']))
    lines.append('-- NEXT '+json.dumps(n['term'],default=str))
   (BASE/'cfg'/f'{name}.txt').write_text('\n'.join(lines))
   print(name,'states',len(graph['nodes']))
  else:
   (BASE/'cfg'/f'{name}.txt').write_text(block(fn['body']))
   print(name,'straight line')
 (BASE/'graphs.json').write_text(json.dumps(result))
