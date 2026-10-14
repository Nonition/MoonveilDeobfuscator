# Archived mapping step for this one analyzed input, not the new generic engine.
import json
from pathlib import Path
ast=json.loads(Path('ast.json').read_text())
call=ast['body'][0]['arguments'][0]
names=[f['value']['value'] for f in call['arguments'][0]['fields']]
fields=json.loads(Path('fields.json').read_text())
for field in fields:
    index=field['key']
    field['name']=names[(0x19927*(index-1)+0x7e73)%len(names)] if isinstance(index,int) else index
Path('mapped_fields.json').write_text(json.dumps(fields,indent=2))
