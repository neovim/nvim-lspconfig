local util = require 'lspconfig.util'

local bin_name = 'ocaml-language-server'
local cmd = { bin_name, '--stdio' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, '--stdio' }
end
local workspace_markers = { '*.opam', 'esy.json', 'package.json' }

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'ocaml', 'reason' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  docs = {
    description = [[
https://github.com/ocaml-lsp/ocaml-language-server

`ocaml-language-server` can be installed via `npm`
```sh
npm install -g ocaml-language-server
```
    ]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
