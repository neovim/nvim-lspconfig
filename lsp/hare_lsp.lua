---@brief
---
--- https://sr.ht/~whynothugo/hare-lsp/
---
--- Language server for hare.

---@type vim.lsp.Config
return {
  cmd = { 'hare-lsp', '-S' },
  filetypes = { 'hare' },
  root_markers = { '.git' },
  workspace_required = false,
}
