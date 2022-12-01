local util = require 'lspconfig.util'

local workspace_markers = {
  'pyproject.toml',
  'setup.py',
  'setup.cfg',
  'requirements.txt',
  'Pipfile',
}

return {
  default_config = {
    cmd = { 'jedi-language-server' },
    filetypes = { 'python' },
    root_dir = util.root_pattern(unpack(workspace_markers)),
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/pappasam/jedi-language-server

`jedi-language-server`, a language server for Python, built on top of jedi
    ]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
