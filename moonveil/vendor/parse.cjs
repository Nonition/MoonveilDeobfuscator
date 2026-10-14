'use strict';
// Vendored parser only: the supplied Lua is parsed, never evaluated by Node.
const fs = require('fs');
const parser = require('./luaparse.js');
try {
  const input = fs.readFileSync(0);
  if (input.length > 4 * 1024 * 1024) throw new Error('Parser input exceeds 4 MiB');
  const ast = parser.parse(input.toString('latin1'), {
    luaVersion: '5.3', encodingMode: 'x-user-defined',
    ranges: true, comments: false
  });
  process.stdout.write(JSON.stringify(ast));
} catch (error) {
  process.stderr.write(String(error.message).slice(0, 2000) + '\n');
  process.exitCode = 2;
}
