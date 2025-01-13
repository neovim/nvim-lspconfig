local util = require('lspconfig.util')

return {
  default_config = {
    cmd = { 'selene-3p-language-server' },
    filetypes = { 'lua' },
    root_dir = util.root_pattern('selene.toml'),
  },
  docs = {
    description = [[
https://github.com/antonk52/lua-3p-language-servers

3rd party Language Server for Selene lua linter
]],
  },
}
