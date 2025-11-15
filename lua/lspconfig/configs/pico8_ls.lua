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
    cmd = { 'pico8-ls', '--stdio' },
    filetypes = { 'p8' },
    root_dir = util.root_pattern '*.p8',
    settings = {},
  },
  docs = {
    description = [[
https://github.com/japhib/pico8-ls

Full language support for the PICO-8 dialect of Lua.
]],
  },
}
