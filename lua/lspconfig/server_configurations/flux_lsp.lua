local util = require 'lspconfig.util'

local workspace_markers = { '.git' }

return {
  default_config = {
    cmd = { 'flux-lsp' },
    filetypes = { 'flux' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/influxdata/flux-lsp
`flux-lsp` can be installed via `cargo`:
```sh
cargo install --git https://github.com/influxdata/flux-lsp
```
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
