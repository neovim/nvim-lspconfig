---@brief
---
--- https://github.com/mtshiba/pylyzer
---
--- `pylyzer`, a fast static code analyzer & language server for Python.
---
--- `pylyzer` requires Erg as dependency, and finds it via `ERG_PATH` environment variable.
--- This config sets `ERG_PATH="~/.erg"`. Set `cmd_env` if you want to change it.
--- To install Erg, simply extract tarball/zip from [Erg releases](https://github.com/erg-lang/erg/releases/latest)
--- to the the path where you want to install it, e.g. `~/.erg`.
return {
  cmd = { 'pylyzer', '--server' },
  filetypes = { 'python' },
  root_markers = {
    'setup.py',
    'tox.ini',
    'requirements.txt',
    'Pipfile',
    'pyproject.toml',
    '.git',
  },
  settings = {
    python = {
      diagnostics = true,
      inlayHints = true,
      smartCompletion = true,
      checkOnType = false,
    },
  },
  cmd_env = {
    ERG_PATH = vim.env.ERG_PATH or vim.fs.joinpath(vim.uv.os_homedir(), '.erg'),
  },
}
