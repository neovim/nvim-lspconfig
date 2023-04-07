local util = require('lspconfig').util

local bin_name = 'pylyzer'
local cmd = { bin_name, '--server' }

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'python' },
    root_dir = function(fname)
      local root_files = {
        'setup.py',
        'tox.ini',
        'requirements.txt',
        'Pipfile',
        'pyproject.toml',
      }
      return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
    end,
    settings = {
      python = {
        diagnostics = true,
        inlayHints = true,
        smartCompletion = true,
        checkOnType = false,
      },
    },
  },
  docs = {
    description = [[
  https://github.com/mtshiba/pylyzer

  `pylyzer`, a fast static code analyzer & language server for Python.
    ]],
  },
}
