#!/bin/sh
# exec nvim-master -u NONE +'set rtp+=$PWD' +'luafile scripts/docgen.lua'
exec nvim-master -u NONE -E -R --headless +'set rtp+=$PWD' +'luafile scripts/docgen.lua' +q
#exec nvim-master -u NONE -Es +'set rtp+=$PWD' +'luafile scripts/docgen.lua' +q
