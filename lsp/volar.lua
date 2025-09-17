---@brief
---
--- Renamed to [vue_ls](#vue_ls)
---
---
vim.deprecate('volar', 'vue_ls', '3.0.0', 'nvim-lspconfig', false)

---@type vim.lsp.Config
return vim.lsp.config.vue_ls
