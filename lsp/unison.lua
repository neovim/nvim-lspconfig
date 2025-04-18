---@brief
---
-- https://github.com/unisonweb/unison/blob/trunk/docs/language-server.markdown
return {
  cmd = { 'nc', 'localhost', os.getenv 'UNISON_LSP_PORT' or '5757' },
  filetypes = { 'unison' },
  root_markers = function(name, _)
    return vim.glob.to_lpeg('*.u'):match(name) ~= nil
  end,
  settings = {},
}
