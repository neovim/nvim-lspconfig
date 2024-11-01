local util = require 'lspconfig.util'

return {
  default_config = {

    cmd = { 'buf', 'beta', 'lsp' },
    filetypes = { 'proto' },
    root_dir = function(fname)
      return require('lspconfig.util').root_pattern('buf.work.yaml', '.git')(fname)
    end,
  },
  docs = {
    description = [[
https://github.com/bufbuild/buf

buf beta lsp included in the cli itself

buf beta lsp is a Protobuf language server compatible with Buf modules and workspaces
]],
  },
}
