local util = require 'lspconfig.util'

local bin_name = 'pact-lsp'
local cmd = { bin_name }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name }
end

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'pact' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/kadena-io/pact-lsp

The Pact language server
    ]],
  },
}
