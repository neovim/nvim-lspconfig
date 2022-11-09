local util = require 'lspconfig.util'

local workspace_markers = { '.git' }

return {
  default_config = {
    cmd = { 'hdl_checker', '--lsp' },
    filetypes = { 'vhdl', 'verilog', 'systemverilog' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/suoto/hdl_checker
Language server for hdl-checker.
Install using: `pip install hdl-checker --upgrade`
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
