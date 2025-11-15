-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- This config is DEPRECATED.
-- Use the configs in `lsp/` instead (requires Nvim 0.11).
--
-- ALL configs in `lua/lspconfig/configs/` will be DELETED.
-- They exist only to support Nvim 0.10 or older.
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'bufls', 'serve' },
    filetypes = { 'proto' },
    root_dir = function(fname)
      return util.root_pattern('buf.work.yaml', '.git')(fname)
    end,
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
  },
}
