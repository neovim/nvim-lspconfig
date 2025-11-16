---@brief
---
--- Renamed to [vsrocq](#vsrocq)

vim.deprecate('vscoqtop', 'vsrocq', '2.0.0', 'nvim-lspconfig', false)

---@type vim.lsp.Config
return vim.lsp.config.vsrocq
