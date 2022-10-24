local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'anakin-language-server' },
    filetypes = { 'python' },
    root_dir = function(fname)
      local root_files = {
        'pyproject.toml',
        'setup.py',
        'setup.cfg',
        'requirements.txt',
        'Pipfile',
      }
      return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://pypi.org/project/anakin-language-server/

`anakin-language-server` is yet another Jedi Python language server.
    ]],
  },
}
