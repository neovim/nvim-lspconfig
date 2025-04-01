local util = require 'lspconfig.util'

---@brief
---
---https://github.com/japhib/pico8-ls
--
-- Full language support for the PICO-8 dialect of Lua.
return {
  cmd = { 'pico8-ls', '--stdio' },
  filetypes = { 'p8' },
  root_dir = function(bufnr, done_callback)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    done_callback(util.root_pattern('*.p8')(fname))
  end,
  settings = {},
}
