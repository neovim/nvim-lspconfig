#!/bin/sh
exec nvim -u NONE -E -R --headless +'set rtp+=$PWD' +'luafile scripts/package_json_gen.lua' +q
