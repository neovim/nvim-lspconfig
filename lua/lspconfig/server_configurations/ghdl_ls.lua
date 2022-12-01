local util = require 'lspconfig.util'

local workspace_markers = { 'hdl-prj.json', '.git' }
return {
  default_config = {
    cmd = { 'ghdl-ls' },
    filetypes = { 'vhdl' },
    root_dir = util.root_pattern(unpack(workspace_markers)),
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/ghdl/ghdl-language-server

A language server for VHDL, using ghdl as its backend.

`ghdl-ls` is part of pyghdl, for installation instructions see
[the upstream README](https://github.com/ghdl/ghdl/tree/master/pyGHDL/lsp).
]],
    workspace_markers = workspace_markers,
  },
}
