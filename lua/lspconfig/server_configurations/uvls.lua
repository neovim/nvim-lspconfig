
local util = require 'lspconfig.util'
return {
  default_config = {
    cmd = {'uvls'},
    filetypes = { 'uvl' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
Language server for uvl, written using tree sitter in rust.
]],
    default_config = {
      root_dir = [[util.find_git_ancestor]],
    },
  },
}
