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
      return vim.fs.dirname(vim.fs.find({ unpack(root_files), '.git' }, { path = fname, upward = true })[1])
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
  },
  docs = {
    description = [[
  https://github.com/mtshiba/pylyzer

  `pylyzer`, a fast static code analyzer & language server for Python.
    ]],
  },
}
