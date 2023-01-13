local util = require 'lspconfig.util'

local cmd = { 'futhark', 'lsp' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', 'futhark', 'lsp' }
end

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'futhark', 'fut' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/diku-dk/futhark

Futhark Language Server

This language server comes with the futhark compiler and is run with the command
```
futhark lsp
```
]],
  },
}
