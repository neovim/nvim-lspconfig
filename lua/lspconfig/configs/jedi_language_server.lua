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
    cmd = { 'jedi-language-server' },
    filetypes = { 'python' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ unpack(root_files) }, { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/pappasam/jedi-language-server

`jedi-language-server`, a language server for Python, built on top of jedi
    ]],
  },
}
