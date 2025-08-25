---@brief
---
--- https://github.com/coq-community/vscoq

---@type vim.lsp.Config
return {
  cmd = { 'vscoqtop' },
  filetypes = { 'coq' },
  root_markers = { '_CoqProject', '.git' },
}
