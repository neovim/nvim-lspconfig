-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- This config is DEPRECATED.
-- Use the configs in `lsp/` instead (requires Nvim 0.11).
--
-- ALL configs in `lua/lspconfig/configs/` will be DELETED.
-- They exist only to support Nvim 0.10 or older.
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
local util = require('lspconfig.util')

return {
  default_config = {
    cmd = { 'stylua-3p-language-server' },
    filetypes = { 'lua' },
    root_dir = util.root_pattern('.stylua.toml', 'stylua.toml'),
  },
  docs = {
    description = [[
https://github.com/antonk52/lua-3p-language-servers

3rd party Language Server for Stylua lua formatter
]],
  },
}
