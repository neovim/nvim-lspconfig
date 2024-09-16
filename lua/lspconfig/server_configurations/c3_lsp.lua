local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'c3lsp' },
    filetypes = { 'c3', 'c3i' },
    root_dir = function(fname)
      return util.root_pattern('project.json', '.git')(fname)
    end,
  },
  docs = {
    description = [[
https://github.com/pherrymason/c3-lsp

Language server for the C3 language.
]],
    default_config = {
      root_dir = [[root_pattern('project.json', '.git')]],
    },
  },
}
