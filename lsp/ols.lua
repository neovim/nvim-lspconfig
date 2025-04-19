---@brief
---
--- https://github.com/DanielGavin/ols
---
--- `Odin Language Server`.

local util = require 'lspconfig.util'

return {
  cmd = { 'ols' },
  filetypes = { 'odin' },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    on_dir(util.root_pattern('ols.json', '.git', '*.odin')(fname))
  end,
}
