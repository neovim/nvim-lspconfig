local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'c3lsp' },
    root_dir = function(fname)
      return util.root_pattern { 'project.json', 'manifest.json', '.git' }(fname)
    end,
    filetypes = { 'c3', 'c3i' },
  },
  docs = {
    description = [[
https://github.com/pherrymason/c3-lsp

Language Server for c3.
]],
  },
}
