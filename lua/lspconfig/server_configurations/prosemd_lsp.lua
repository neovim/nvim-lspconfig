local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'prosemd-lsp', '--stdio' },
    filetypes = { 'markdown' },
    root_dir = function(fname)
      return util.find_git_ancestor(fname) or vim.fn.getcwd()
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/kitten/prosemd-lsp

An experimental LSP for Markdown.
]],
    default_config = {
      root_dir = [[find_git_ancestor(fname) or vim.fn.getcwd()]],
    },
  },
}
