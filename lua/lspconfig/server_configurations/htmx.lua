local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'htmx-lsp' },
    filetypes = { 'html' },
    root_dir = function(fname)
      return util.find_git_ancestor(fname) or vim.fn.expand '%:p:h' or vim.loop.os_homedir()
    end,
    settings = {},
  },
  docs = {
    description = [[
https://github.com/ThePrimeagen/htmx-lsp

`htmx-lsp` can be installed via `cargo`:
```sh
cargo install htmx-lsp
```

Lsp is still very much work in progress and experimental. Use at your own risk.
]],
  },
}
