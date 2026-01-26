---@brief
---
--- Renamed to [vsrocq](#vsrocq)

---@type vim.lsp.Config
return vim.tbl_extend('force', vim.lsp.config.vsrocq, {
  on_init = function(...)
    vim.deprecate('vscoqtop', 'vsrocq', '3.0.0', 'nvim-lspconfig', false)
    if vim.lsp.config.vsrocq.on_init then
      vim.lsp.config.vsrocq.on_init(...)
    end
  end,
})
