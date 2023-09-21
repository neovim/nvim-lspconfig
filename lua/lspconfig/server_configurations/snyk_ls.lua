local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'snyk-ls' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
    filetypes = {},
    settings = {},
    init_options = {},
  },
  docs = {
    description = [[
https://github.com/snyk/snyk-ls

LSP for Snyk Open Source, Snyk Infrastructure as Code, and Snyk Code.
]],
    default_config = {
      filetypes = 'Empty by default, override to add filetypes',
      root_dir = "Vim's starting directory",
      init_options = 'Configuration from https://github.com/snyk/snyk-ls#configuration-1',
    },
  },
}
