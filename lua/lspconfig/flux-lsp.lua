local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = 'flux-lsp'
local bin_name = 'flux-lsp'

configs[server_name] = {
  default_config = {
    cmd = { bin_name },
    filetypes = { 'flux' },
    root_dir = util.find_git_ancestor,
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
      root_dir = [[util.find_git_ancestor]],
    },
  },
}

-- vim:et ts=2 sw=2
