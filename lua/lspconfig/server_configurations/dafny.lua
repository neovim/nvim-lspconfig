local util = require 'lspconfig.util'

return {
  default_config = {
    filetypes = { 'dfy', 'dafny' },
    cmd = { 'dotnet', '/opt/dafny/DafnyLanguageServer.dll' },
    root_dir = function(fname)
      util.find_git_ancestor(fname)
    end,
    single_file_support = true
  },
  docs = {
    description = [[
    Lsp for dafny
]],
  },
}
