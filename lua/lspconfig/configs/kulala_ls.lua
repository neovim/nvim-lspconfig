local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'kulala-ls', '--stdio' },
    filetypes = { 'http' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/mistweaverco/kulala-ls

A minimal language server for HTTP syntax.
]],
  },
}
