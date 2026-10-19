---@brief
---
--- [OpenTofu Language Server](https://github.com/opentofu/tofu-ls)
---

---@type vim.lsp.Config
return {
  cmd = { 'tofu-ls', 'serve' },
  filetypes = { 'opentofu', 'opentofu-vars', 'terraform', 'terraform-vars' },
  root_markers = { '.terraform', '.git' },
}
