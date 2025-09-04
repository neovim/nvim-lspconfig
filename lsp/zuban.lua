---@brief
---
--- https://zubanls.com/
---
--- A high-performance Python Language Server and type checker implemented in Rust, by the author of Jedi.

---@type vim.lsp.Config
return {
  cmd = { 'zuban', 'server' },
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
