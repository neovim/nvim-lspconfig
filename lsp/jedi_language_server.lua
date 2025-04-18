---@brief
---
--- https://github.com/pappasam/jedi-language-server
---
--- `jedi-language-server`, a language server for Python, built on top of jedi
return {
  cmd = { 'jedi-language-server' },
  filetypes = { 'python' },
  root_markers = {
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
    '.git',
  },
}
