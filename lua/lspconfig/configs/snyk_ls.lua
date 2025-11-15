-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- This config is DEPRECATED.
-- Use the configs in `lsp/` instead (requires Nvim 0.11).
--
-- ALL configs in `lua/lspconfig/configs/` will be DELETED.
-- They exist only to support Nvim 0.10 or older.
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'snyk-ls' },
    root_dir = util.root_pattern('.git', '.snyk'),
    filetypes = {
      'go',
      'gomod',
      'javascript',
      'typescript',
      'json',
      'python',
      'requirements',
      'helm',
      'yaml',
      'terraform',
      'terraform-vars',
    },
    single_file_support = true,
    settings = {},
    -- Configuration from https://github.com/snyk/snyk-ls#configuration-1
    init_options = {
      activateSnykCode = 'true',
    },
  },
  docs = {
    description = [[
https://github.com/snyk/snyk-ls

LSP for Snyk Open Source, Snyk Infrastructure as Code, and Snyk Code.
]],
  },
}
