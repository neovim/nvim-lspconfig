local util = require 'lspconfig.util'

local bin_name = 'hdl_checker'
local cmd = { bin_name, '--lsp' }

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'vhdl', 'verilog', 'systemverilog' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/suoto/hdl_checker
Language server for hdl-checker.
Install using: `pip install hdl-checker --upgrade`
]],
    default_config = {
      root_dir = [[util.find_git_ancestor]],
    },
  },
}
