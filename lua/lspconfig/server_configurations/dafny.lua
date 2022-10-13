local util = require 'lspconfig.util'

local root_files = {
    'compile_commands.json',
    '.ccls',
}
return {
  default_config = {
    filetypes = { 'dfy', 'dafny'},
    cmd = { 'dotnet', '/opt/dafny/DafnyLanguageServer.dll' },
    root_dir = function(fname)
      return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
    end,
  },
  docs = {
    description = [[
    Lsp for dafny
]],
  },
}
