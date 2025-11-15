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
    cmd = { 'pbls' },
    filetypes = { 'proto' },
    root_dir = util.root_pattern('.pbls.toml', '.git'),
  },
  docs = {
    description = [[
https://git.sr.ht/~rrc/pbls

Prerequisites: Ensure protoc is on your $PATH.

`pbls` can be installed via `cargo install`:
```sh
cargo install --git https://git.sr.ht/~rrc/pbls
```

pbls is a Language Server for protobuf
]],
  },
}
