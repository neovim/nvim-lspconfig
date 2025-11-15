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
    cmd = { 'dprint', 'lsp' },
    filetypes = {
      'javascript',
      'javascriptreact',
      'typescript',
      'typescriptreact',
      'json',
      'jsonc',
      'markdown',
      'python',
      'toml',
      'rust',
      'roslyn',
      'graphql',
    },
    root_dir = util.root_pattern('dprint.json', '.dprint.json', 'dprint.jsonc', '.dprint.jsonc'),
    single_file_support = true,
    settings = {},
  },
  docs = {
    description = [[
https://github.com/dprint/dprint

Pluggable and configurable code formatting platform written in Rust.
  ]],
  },
}
