# Third-party notices

## luaparse 0.3.1

Vendored parser: `moonveil/vendor/luaparse.js`.
Upstream: https://github.com/fstirlitz/luaparse
License: MIT, reproduced in `moonveil/vendor/LUAPARSE_LICENSE.txt`.
Local change: preserve a grouping flag in `parsePrefixExpression` to distinguish
parenthesized calls when applying Lua multiple-return semantics. The modification
is commented in the vendored source. No upstream endorsement is implied.

## RideAFish sample and reconstructions

Files in `research/rideafish/` containing game source are supplied for the user's
requested analysis/regression. Upstream ownership/license has not been verified.
They are NOT relicensed under the tooling's MIT license. Preserve attribution and
obtain permission before redistributing these sample contents separately/publicly.

Source URL:
https://gist.githubusercontent.com/spiritualgaming1123-beep/b44f04e014cca2b8c25a0310500680e2/raw/7313e5f149ea060d4d03b128bda37bc9f8e8b6fe/RideAFish

Input SHA-256:
`f235e3843beba872fb69bc2fcc1bc66651ebfeba8a37fd58f366dbb04ed12a4c`

## Optional dependencies

`discord.py` and `lupa` are not vendored. If installed, their respective licenses
apply. The optional regression runner requires Lupa with the LuaJIT 2.1 backend.
A RAR command-line tool was used to create the deliverable archive; its binary is
not included or relicensed by this package.
