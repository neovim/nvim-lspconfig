local util = require 'lspconfig.util'

local bin_name = 'cssmodules-language-server'
local cmd = { bin_name }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name }
end

local workspace_markers = { 'package.json' }

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  docs = {
    description = [[
https://github.com/antonk52/cssmodules-language-server

Language server for autocompletion and go-to-definition functionality for CSS modules.

You can install cssmodules-language-server via npm:
```sh
npm install -g cssmodules-language-server
```
    ]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
