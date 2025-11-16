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
    cmd = { 'statix', 'check', '--stdin' },
    filetypes = { 'nix' },
    single_file_support = true,
    root_dir = util.root_pattern('flake.nix', '.git'),
  },
  docs = {
    description = [[
https://github.com/nerdypepper/statix

lints and suggestions for the nix programming language
    ]],
  },
}
