local util = require 'lspconfig.util'

---@brief
---
---https://github.com/agda/agda-language-server
--
-- Language Server for Agda.
return {
  cmd = { 'als' },
  filetypes = { 'agda' },
  root_dir = function(bufnr, done_callback)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    done_callback(util.root_pattern('.git', '*.agda-lib')(fname))
  end,
}
