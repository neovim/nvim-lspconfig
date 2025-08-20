---@brief
---
--- https://github.com/pherrymason/c3-lsp
---
--- Language Server for c3.

---@type vim.lsp.Config
return {
  cmd = { 'c3lsp' },
  root_markers = { 'project.json', 'manifest.json', '.git' },
  filetypes = { 'c3', 'c3i' },
}
