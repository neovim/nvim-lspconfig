local util = require 'lspconfig.util'

local workspace_markers = { '*.toml', '.git' }

return {
  default_config = {
    cmd = { 'taplo', 'lsp', 'stdio' },
    filetypes = { 'toml' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
    single_file_support = true,
  },
  docs = {
    description = [[
https://taplo.tamasfe.dev/cli/usage/language-server.html

Language server for Taplo, a TOML toolkit.

`taplo-cli` can be installed via `cargo`:
```sh
cargo install --features lsp --locked taplo-cli
```
    ]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
