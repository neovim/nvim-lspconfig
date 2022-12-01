local util = require 'lspconfig.util'

local bin_name = 'rome'
local cmd = { bin_name, 'lsp-proxy' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, 'lsp-proxy' }
end

local workspace_markers = { 'package.json', 'node_modules', '.git' }

return {
  default_config = {
    cmd = cmd,
    filetypes = {
      'javascript',
      'javascriptreact',
      'json',
      'typescript',
      'typescript.tsx',
      'typescriptreact',
    },
    root_dir = util.root_pattern(unpack(workspace_markers)),
    single_file_support = true,
  },
  docs = {
    description = [[
https://rome.tools

Language server for the Rome Frontend Toolchain.

```sh
npm install [-g] rome
```
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
