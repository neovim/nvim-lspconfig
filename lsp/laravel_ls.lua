---@brief
---
--- https://github.com/laravel-ls/laravel-ls
---
--- `laravel-ls`, language server for laravel
---
--- The default `cmd` assumes that the `laravel-ls` binary can be found in `$PATH`.

return {
  cmd = { 'laravel-ls' },
  filetypes = { 'php', 'blade' },
  root_markers = { 'artisan' },
}
