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
