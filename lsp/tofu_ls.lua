---@brief
---
--- [OpenTofu Language Server](https://github.com/opentofu/tofu-ls)
---
return {
  cmd = { 'tofu-ls', 'serve' },
  filetypes = { 'opentofu', 'opentofu-vars' },
  root_markers = { '.terraform', '.git' },
}
