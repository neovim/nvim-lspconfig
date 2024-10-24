local util = require 'lspconfig.util'

return {
  -- Configuration from https://github.com/iamcco/diagnostic-languageserver#config--document
  default_config = {
    cmd = { 'diagnostic-languageserver', '--stdio' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
    -- Empty by default, override to add filetypes.
    filetypes = {},
  },
  docs = {
    description = [[
https://github.com/iamcco/diagnostic-languageserver

Diagnostic language server integrate with linters.
]],
  },
}
