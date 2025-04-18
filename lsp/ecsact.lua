---@brief
---
--- https://github.com/ecsact-dev/ecsact_lsp_server
---
--- Language server for Ecsact.
---
--- The default cmd assumes `ecsact_lsp_server` is in your PATH. Typically from the
--- Ecsact SDK: https://ecsact.dev/start
return {
  cmd = { 'ecsact_lsp_server', '--stdio' },
  filetypes = { 'ecsact' },
  root_markers = { '.git' },
}
