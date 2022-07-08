local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = {'gleam', 'lsp'},
    filetypes = { 'gleam' },
    root_dir = function(fname)
      return util.root_pattern('gleam.toml', '.git')(fname)
    end,
  },
  docs = {
    description = [[
https://github.com/gleam-lang/gleam

A language server for Gleam Programming Language.
]],
    default_config = {
      cmd = { 'gleam', 'lsp' },
      root_dir = [[root_pattern("gleam.toml", ".git")]],
    },
  },
}
