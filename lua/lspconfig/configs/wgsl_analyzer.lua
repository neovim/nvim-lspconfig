local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'wgsl-analyzer' },
    filetypes = { 'wgsl' },
    root_dir = util.root_pattern '.git',
    settings = {},
  },
  docs = {
    description = [[
https://github.com/wgsl-analyzer/wgsl-analyzer

`wgsl-analyzer` can be installed via `cargo`:
```sh
cargo install --git https://github.com/wgsl-analyzer/wgsl-analyzer wgsl-analyzer
```
]],
  },
}
