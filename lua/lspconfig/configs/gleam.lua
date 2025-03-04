local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'gleam', 'lsp' },
    filetypes = { 'gleam' },
    root_dir = function(fname)
      return util.root_pattern('gleam.toml', '.git')(fname)
    end,
  },
  docs = {
    description = [[
https://github.com/gleam-lang/gleam

A language server for Gleam Programming Language.

It comes with the Gleam compiler, for installation see: [Installing Gleam](https://gleam.run/getting-started/installing/)
]],
  },
}
