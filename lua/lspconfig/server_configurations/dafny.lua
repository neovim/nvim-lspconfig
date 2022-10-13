local util = require 'lspconfig.util'

return {
  default_config = {
    filetypes = { 'dfy', 'dafny'},
    cmd = { 'dotnet', '/opt/dafny/DafnyLanguageServer.dll'}
  },
  docs = {
    description = [[
    Lsp for dafny
]],
  },
}
