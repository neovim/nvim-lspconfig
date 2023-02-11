local util = require 'lspconfig.util'

local cmd = { 'fennel-language-server' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', 'fennel-language-server' }
end

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'fennel' },
    single_file_support = true,
    root_dir = util.find_git_ancestor,
    settings = {},
  },
  docs = {
    description = [[
https://github.com/rydesun/fennel-language-server

Fennel language server protocol (LSP) support.
]],
  },
}
