local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = {'gleam', 'lsp'},
    filetypes = { 'gleam' },
    root_dir = function(fname)
      return util.root_pattern('gleam.toml', '.git')(fname) or vim.loop.os_homedir()
    end,
  },
  docs = {
    description = [[
https://github.com/gleam-lang/gleam

```lua
require('lspconfig').gleam.setup({})
```
]],
    default_config = {
      cmd = { 'gleam', 'lsp' },
      root_dir = [[root_pattern("gleam.toml", ".git") or vim.loop.os_homedir()]],
    },
  },
}
