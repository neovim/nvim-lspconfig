local util = require 'lspconfig.util'

---@brief
---
---https://github.com/DanielGavin/ols
--
-- `Odin Language Server`.
return {
  cmd = { 'ols' },
  filetypes = { 'odin' },
  root_dir = function(bufnr, done_callback)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    done_callback(util.root_pattern('ols.json', '.git', '*.odin')(fname))
  end,
}
