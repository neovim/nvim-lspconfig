---@brief
---
--- https://github.com/terraform-linters/tflint
---
--- A pluggable Terraform linter that can act as lsp server.
--- Installation instructions can be found in https://github.com/terraform-linters/tflint#installation.
return {
  cmd = { 'tflint', '--langserver' },
  filetypes = { 'terraform' },
  root_markers = { '.terraform', '.git', '.tflint.hcl' },
}
