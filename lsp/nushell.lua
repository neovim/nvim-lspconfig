---@brief
---
--- https://github.com/nushell/nushell
---
--- Nushell built-in language server.
return {
  cmd = { 'nu', '--lsp' },
  filetypes = { 'nu' },
  root_dir = function(bufnr, on_dir)
    on_dir(vim.fs.root(bufnr, { '.git' }) or vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)))
  end,
}
