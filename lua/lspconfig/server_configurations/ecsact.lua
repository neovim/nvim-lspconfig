local util = require 'lspconfig.util'

local bin_name = 'ecsact_lsp_server'
local cmd = { bin_name, '--stdio' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, '--stdio' }
end

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'ecsact' },
    root_dir = util.root_pattern '.git',
    single_file_support = true,
  },

  docs = {
    description = [[
https://github.com/ecsact-dev/ecsact_lsp_server

Language server for Ecsact.

The default cmd assumes `ecsact_lsp_server` is in your PATH. Typically from the
Ecsact SDK: https://ecsact.dev/start
]],
  },
}
