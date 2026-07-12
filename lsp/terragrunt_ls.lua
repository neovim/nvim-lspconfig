---@brief
---
--- https://github.com/gruntwork-io/terragrunt-ls
---
--- `terragrunt-ls`, a language server for Terragrunt configuration files.

---@type vim.lsp.Config
return {
  cmd = { 'terragrunt-ls' },
  filetypes = { 'hcl' },
  root_markers = { 'terragrunt.hcl', '.git' },
}
