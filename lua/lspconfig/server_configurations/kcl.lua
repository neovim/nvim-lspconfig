local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'kcl-language-server' },
    filetypes = { 'kcl' },
    root_dir = util.root_pattern '.git',
  },
  docs = {
    description = [[
https://github.com/kcl-lang/kcl.nvim

Language server for the KCL configuration adn policy language.

]],
    default_config = {
      root_dir = [[root_pattern(".git")]],
    },
  },
}
