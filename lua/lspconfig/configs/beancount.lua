local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'beancount-language-server', '--stdio' },
    filetypes = { 'beancount', 'bean' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
    init_options = {},
  },
  docs = {
    description = [[
https://github.com/polarmutex/beancount-language-server#installation

See https://github.com/polarmutex/beancount-language-server#configuration for configuration options
]],
  },
}
