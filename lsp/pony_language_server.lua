---@brief
---
--- Renamed to [pony_lsp](#pony_lsp)

---@type vim.lsp.Config
return vim.tbl_extend('force', vim.lsp.config.pony_lsp, {
  on_init = function(...)
    vim.deprecate('pony_language_server', 'pony_lsp', '3.0.0', 'nvim-lspconfig', false)
    if vim.lsp.config.pony_lsp.on_init then
      vim.lsp.config.pony_lsp.on_init(...)
    end
  end,
})
