local util = require 'lspconfig.util'

local bin_name = 'yls'
local cmd = { bin_name, '-vv' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, '-vv' }
end

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'yar', 'yara' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
https://pypi.org/project/yls-yara/

An YLS plugin adding YARA linting capabilities.

This plugin runs yara.compile on every save, parses the errors, and returns list of diagnostic messages.

Language Server: https://github.com/avast/yls
]],
  },
}
