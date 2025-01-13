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
