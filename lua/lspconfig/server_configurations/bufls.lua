local util = require 'lspconfig.util'

local bin_name = 'bufls'
local cmd = { bin_name, 'serve' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, 'start' }
end

local workspace_markers = { 'buf.work.yaml', '.git' }

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'proto' },
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  docs = {
    description = [[
https://github.com/bufbuild/buf-language-server

`buf-language-server` can be installed via `go install`:
```sh
go install github.com/bufbuild/buf-language-server/cmd/bufls@latest
```

bufls is a Protobuf language server compatible with Buf modules and workspaces
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
