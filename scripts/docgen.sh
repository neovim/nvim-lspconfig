#!/bin/sh
exec nvim-master -u NONE -E -R --headless +'set rtp+=$PWD' +'luafile scripts/docgen.lua' +q
