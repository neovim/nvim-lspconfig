---@brief
---
--- https://github.com/mtshiba/pylyzer
---
--- `pylyzer`, a fast static code analyzer & language server for Python.
---
--- `pylyzer` requires Erg as dependency, and finds it via `ERG_PATH` environment variable.
--- In the default config `ERG_PATH` is set to `~/.erg`, as shown in the `on_new_config` function.
--- Add a `on_new_config` on your own if you want to change it.
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
  on_new_config = function(new_config, _)
    new_config.cmd_env.ERG_PATH = vim.fs.joinpath(vim.uv.os_homedir(), '/.erg')
  end,
}
