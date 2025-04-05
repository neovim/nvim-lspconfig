local util = require 'lspconfig.util'

---@brief
---
---https://github.com/unisonweb/unison/blob/trunk/docs/language-server.markdown
return {
  cmd = { 'nc', 'localhost', os.getenv 'UNISON_LSP_PORT' or '5757' },
  filetypes = { 'unison' },
  root_dir = function(bufnr, done_callback)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    done_callback(util.root_pattern('*.u')(fname))
  end,
  settings = {},
}
