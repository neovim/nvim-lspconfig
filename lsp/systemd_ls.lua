---@brief
---
--- Renamed to [systemd_lsp](#systemd_lsp)

---@type vim.lsp.Config
return vim.tbl_extend('force', vim.lsp.config.systemd_lsp, {
  on_init = function(...)
    vim.deprecate('systemd_ls', 'systemd_lsp', '3.0.0', 'nvim-lspconfig', false)
    if vim.lsp.config.systemd_lsp.on_init then
      vim.lsp.config.systemd_lsp.on_init(...)
    end
  end,
})
