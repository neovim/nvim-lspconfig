---@brief
---
--- Deprecated in favor of [tsc](#tsc)

---@type vim.lsp.Config
return vim.tbl_extend('force', vim.lsp.config.tsc, {
  on_init = function(...)
    vim.deprecate('tsgo', 'tsc', '3.0.0', 'nvim-lspconfig', false)
    if vim.lsp.config.tsc.on_init then
      vim.lsp.config.tsc.on_init(...)
    end
  end,
})
