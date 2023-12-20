local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'snyk-ls' },
    root_dir = util.root_pattern '.git',
    single_file_support = true,
    settings = {},
    init_options = {},
  },
  docs = {
    description = [[
https://github.com/snyk/snyk-ls

LSP for Snyk Open Source, Snyk Infrastructure as Code, and Snyk Code.
]],
    default_config = {
      root_dir = [[root_pattern(".git")]],
      init_options = 'Configuration from https://github.com/snyk/snyk-ls#configuration-1',
    },
  },
}
