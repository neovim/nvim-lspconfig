---@brief
---
--- https://github.com/agda/agda-language-server
---
--- Language Server for Agda.

local util = require 'lspconfig.util'

return {
  cmd = { 'als' },
  filetypes = { 'agda' },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    on_dir(util.root_pattern('.git', '*.agda-lib')(fname))
  end,
}
