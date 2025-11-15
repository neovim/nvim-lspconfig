-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- This config is DEPRECATED.
-- Use the configs in `lsp/` instead (requires Nvim 0.11).
--
-- ALL configs in `lua/lspconfig/configs/` will be DELETED.
-- They exist only to support Nvim 0.10 or older.
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
local util = require 'lspconfig/util'

return {
  default_config = {
    cmd = { 'earthlyls' },
    filetypes = { 'earthfile' },
    root_dir = util.root_pattern 'Earthfile',
  },
  docs = {
    description = [[
https://github.com/glehmann/earthlyls

A fast language server for earthly.
]],
  },
}
