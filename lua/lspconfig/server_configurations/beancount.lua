local util = require 'lspconfig.util'

local workspace_markers = { '.git' }

return {
  default_config = {
    cmd = { 'beancount-language-server', '--stdio' },
    filetypes = { 'beancount', 'bean' },
    root_dir = util.root_pattern(unpack(workspace_markers)),
    single_file_support = true,
    init_options = {
      -- this is the path to the beancout journal file
      journalFile = '',
    },
  },
  docs = {
    description = [[
https://github.com/polarmutex/beancount-language-server#installation

See https://github.com/polarmutex/beancount-language-server#configuration for configuration options
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
