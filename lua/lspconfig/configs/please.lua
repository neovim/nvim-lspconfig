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
    cmd = { 'plz', 'tool', 'lps' },
    filetypes = { 'bzl' },
    root_dir = util.root_pattern '.plzconfig',
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/thought-machine/please

High-performance extensible build system for reproducible multi-language builds.

The `plz` binary will automatically install the LSP for you on first run
]],
  },
}
