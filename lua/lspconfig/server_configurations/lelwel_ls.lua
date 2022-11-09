local util = require 'lspconfig.util'

local workspace_markers = { '.git' }

return {
  default_config = {
    cmd = { 'lelwel-ls' },
    filetypes = { 'llw' },
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  docs = {
    description = [[
https://github.com/0x2a-42/lelwel

Language server for lelwel grammars.

You can install `lelwel-ls` via cargo:
```sh
cargo install --features="lsp" lelwel
```
]],
  },
}
