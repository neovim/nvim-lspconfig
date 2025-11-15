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
    cmd = { 'laravel-ls' },
    filetypes = { 'php', 'blade' },
    root_dir = util.root_pattern({ 'artisan' }),
  },
  docs = {
    description = [[
https://github.com/laravel-ls/laravel-ls

`laravel-ls`, language server for laravel

The default `cmd` assumes that the `laravel-ls` binary can be found in `$PATH`.
    ]],
  },
}
