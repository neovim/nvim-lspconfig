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
    cmd = { 'templ', 'lsp' },
    filetypes = { 'templ' },
    root_dir = function(fname)
      return util.root_pattern('go.work', 'go.mod', '.git')(fname)
    end,
  },
  docs = {
    description = [[
https://templ.guide

The official language server for the templ HTML templating language.
]],
  },
}
