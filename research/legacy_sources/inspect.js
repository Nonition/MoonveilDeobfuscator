const fs=require('fs'), lp=require('luaparse');
const src=fs.readFileSync('decoded.lua','utf8');
const ast=lp.parse(src,{luaVersion:'5.3',ranges:true,encodingMode:'x-user-defined'});
fs.writeFileSync('decoded_ast.json',JSON.stringify(ast));
const fields=JSON.parse(fs.readFileSync('mapped_fields.json','utf8'));
const table=ast.body[0].arguments[0].base.base;
fs.mkdirSync('functions',{recursive:true});
table.fields.forEach((f,i)=>fs.writeFileSync('functions/'+fields[i].name+'.lua','return '+src.slice(...f.value.range)+'\n'));
console.log('Decoded source bytes',src.length);
