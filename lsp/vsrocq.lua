---@brief
---
--- https://github.com/rocq-prover/vsrocq

---@type vim.lsp.Config
return {
  cmd = { 'vsrocqtop' },
  filetypes = { 'coq' },
  root_markers = { '_RocqProject', '_CoqProject', '.git' },
}
