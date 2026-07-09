---@brief
---
--- https://github.com/kdl-org/kdl-rs/tree/main/tools/kdl-lsp
---
--- Language server for the KDL document language.
---

---@type vim.lsp.Config
return {
  cmd = { 'kdl-lsp' },
  filetypes = { 'kdl' },
  root_markers = { '.git' },
}
