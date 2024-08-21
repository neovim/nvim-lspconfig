local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = {
      'janet-lsp',
      '--stdio',
    },
    filetypes = { 'janet' },
    root_dir = util.root_pattern 'project.janet' or util.find_git_ancestor(),
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/CFiggers/janet-lsp

A Language Server Protocol implementation for Janet.
]],
    root_dir = [[root_pattern("project.janet", ".git")]],
  },
}
