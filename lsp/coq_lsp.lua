---@brief
---
--- https://github.com/ejgallego/coq-lsp/

---@type vim.lsp.Config
return {
  cmd = { 'coq-lsp' },
  filetypes = { 'coq' },
  root_markers = { '_CoqProject', '.git' },
}
