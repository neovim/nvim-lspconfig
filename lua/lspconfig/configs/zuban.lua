local util = require 'lspconfig.util'

local root_files = {
  'pyproject.toml',
  'setup.py',
  'setup.cfg',
  'requirements.txt',
  'Pipfile',
  '.git',
}

return {
  default_config = {
    cmd = { 'zuban', 'server' },
    filetypes = { 'python' },
    root_dir = function(fname)
      return util.root_pattern(unpack(root_files))(fname)
    end,
  },
  docs = {
    description = [[
https://zubanls.com/

A high-performance Python Language Server and type checker implemented in Rust, by the author of Jedi.
]],
  },
}
