---@brief
---
--- https://github.com/elbywan/crystalline
---
--- Crystal language server.

---@type vim.lsp.Config
return {
  cmd = { 'crystalline' },
  filetypes = { 'crystal' },
  root_markers = { 'shard.yml', '.git' },
}
