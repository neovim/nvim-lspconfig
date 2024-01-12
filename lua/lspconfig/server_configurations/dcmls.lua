local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'dcm', 'start-server' },
    filetypes = { 'dart' },
    root_dir = util.root_pattern 'pubspec.yaml',
  },
  docs = {
    description = [[
https://dcm.dev/

Language server for dart.
]],
    default_config = {
      root_dir = [[root_pattern("pubspec.yaml")]],
    },
  },
}
