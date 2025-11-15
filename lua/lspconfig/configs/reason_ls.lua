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
    cmd = { 'reason-language-server' },
    filetypes = { 'reason' },
    root_dir = util.root_pattern('bsconfig.json', '.git'),
  },
  docs = {
    description = [[
Reason language server

You can install reason language server from [reason-language-server](https://github.com/jaredly/reason-language-server) repository.
]],
  },
}
