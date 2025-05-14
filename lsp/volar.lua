---@brief
---
--- Renamed to [vue_ls](#vue_ls)
---
---
vim.deprecate('volar', 'vue_ls', '3.0.0', 'lspconfig', false)

return vim.lsp.config.vue_ls
