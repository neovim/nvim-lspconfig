---@brief
---
--- Renamed to [systemd_lsp](#systemd_lsp)

vim.deprecate('systemd_ls', 'systemd_lsp', '3.0.0', 'nvim-lspconfig', false)

---@type vim.lsp.Config
return vim.lsp.config.systemd_lsp
