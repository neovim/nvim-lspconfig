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
    cmd = { 'c3lsp' },
    root_dir = function(fname)
      return util.root_pattern { 'project.json', 'manifest.json', '.git' }(fname)
    end,
    filetypes = { 'c3', 'c3i' },
  },
  docs = {
    description = [[
https://github.com/pherrymason/c3-lsp

Language Server for c3.
]],
  },
}
