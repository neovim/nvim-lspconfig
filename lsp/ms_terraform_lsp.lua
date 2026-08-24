---@brief
---
--- https://github.com/Azure/ms-terraform-lsp
---
--- Microsoft Terraform Providers Language Server. Provides completion, hover
--- documentation and schema validation for the `azapi`, `azurerm` and `msgraph`
--- providers, and for Azure Verified Modules.
---
--- Only covers Microsoft providers, so it is intended to run alongside
--- [terraformls](#terraformls).
---
--- Download a released binary from
--- https://github.com/Azure/ms-terraform-lsp/releases.

---@type vim.lsp.Config
return {
  cmd = { 'ms-terraform-lsp', 'serve' },
  filetypes = { 'terraform' },
  root_markers = { '.terraform', '.git' },
}
