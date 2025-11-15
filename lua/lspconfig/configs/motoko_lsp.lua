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
    cmd = { 'motoko-lsp', '--stdio' },
    filetypes = { 'motoko' },
    root_dir = util.root_pattern('dfx.json', '.git'),
    init_options = {
      formatter = 'auto',
    },
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/dfinity/vscode-motoko

Language server for the Motoko programming language.
    ]],
  },
}
