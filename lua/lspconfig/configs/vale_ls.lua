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
    cmd = { 'vale-ls' },
    filetypes = { 'markdown', 'text', 'tex', 'rst' },
    root_dir = util.root_pattern '.vale.ini',
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/errata-ai/vale-ls

An implementation of the Language Server Protocol (LSP) for the Vale command-line tool.
]],
  },
}
