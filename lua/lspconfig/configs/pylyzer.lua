local util = require('lspconfig').util

return {
  default_config = {
    cmd = { 'pylyzer', '--server' },
    filetypes = { 'python' },
    root_dir = function(fname)
      local root_files = {
        'setup.py',
        'tox.ini',
        'requirements.txt',
        'Pipfile',
        'pyproject.toml',
      }
      return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
    end,
    single_file_support = true,
    settings = {
      python = {
        diagnostics = true,
        inlayHints = true,
        smartCompletion = true,
        checkOnType = false,
      },
    },
    ergPath = vim.fn.getenv('HOME') .. '/.erg',
    on_new_config = function(new_config, _)
      if new_config.ergPath then
        new_config.cmd_env.ERG_PATH = new_config.ergPath
      end
    end,
  },
  docs = {
    description = [[
  https://github.com/mtshiba/pylyzer

  `pylyzer`, a fast static code analyzer & language server for Python.

  `pylyzer` requires Erg as dependency, and finds it via `ERG_PATH` environment variable.
  By default `ERG_PATH` is set to `~/.erg` when `lspconfig` runs `pylyzer`,
  pass `ergPath = "/path/to/erg"` if you want to change it.

  To install Erg, simply extract tarball/zip from [Erg releases](https://github.com/erg-lang/erg/releases/latest)
  to the the path where you want to install it, e.g. `~/.erg`.
    ]],
  },
}
