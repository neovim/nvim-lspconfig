local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'koka', '--language-server', '--lsstdio' },
    filetypes = { 'koka' },
    single_file_support = true,
    root_dir = util.find_git_ancestor,
  },

  docs = {
    description = [[
    https://koka-lang.github.io/koka/doc/index.html
Koka is a functional programming language with effect types and handlers.
    ]],
  },
}
