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
    cmd = { 'mesonlsp', '--lsp' },
    filetypes = { 'meson' },
    root_dir = util.root_pattern('meson.build', 'meson_options.txt', 'meson.options', '.git'),
  },
  docs = {
    description = [[
https://github.com/JCWasmx86/mesonlsp

An unofficial, unendorsed language server for meson written in C++
]],
  },
}
