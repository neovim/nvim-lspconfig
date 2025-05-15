---@brief
---
--- https://github.com/unisonweb/unison/blob/trunk/docs/language-server.markdown

return {
  cmd = { 'nc', 'localhost', os.getenv 'UNISON_LSP_PORT' or '5757' },
  filetypes = { 'unison' },
  root_dir = function(bufnr, on_dir)
    on_dir(vim.fs.root(bufnr, function(name, _)
      return vim.glob.to_lpeg('*.u'):match(name) ~= nil
    end))
  end,
  settings = {},
}
