local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'uiua', 'lsp' },
    filetypes = { 'uiua' },
    root_dir = util.find_git_ancestor,
  },
  docs = {
    description = [[
https://github.com/uiua-lang/uiua/

The builtin language server of the Uiua interpreter.

The Uiua interpreter can be installed with `cargo install uiua`
]],
    default_config = {
      cmd = { 'uiua', 'lsp' },
      filetypes = { 'uiua' },
      root_dir = [[util.find_git_ancestor]],
    },
  },
}
