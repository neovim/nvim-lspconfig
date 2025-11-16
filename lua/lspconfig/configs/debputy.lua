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
    cmd = { 'debputy', 'lsp', 'server' },
    filetypes = { 'debcontrol', 'debcopyright', 'debchangelog', 'make', 'yaml' },
    root_dir = util.root_pattern 'debian',
  },
  docs = {
    description = [[
https://salsa.debian.org/debian/debputy

Language Server for Debian packages.
]],
  },
}
