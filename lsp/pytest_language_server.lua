---@brief
---
--- https://github.com/bellini666/pytest-language-server
---
--- `pytest-language-server`, a Language Server Protocol implementation for pytest.
---
--- Features:
--- - Go to definition for fixtures (local, conftest.py, and third-party plugins)
--- - Find references for fixtures across the test suite
--- - Hover documentation with fixture signatures, return types, and docstrings
--- - Code completion for available fixtures with hierarchy-aware suggestions
--- - Diagnostics for undeclared fixtures used in test bodies
--- - Code actions (quick fixes) to add missing fixture parameters
--- - Supports fixture overriding and pytest's fixture priority rules
--- - Character-position aware for self-referencing fixtures
---@type vim.lsp.Config
return {
  cmd = { 'pytest-language-server' },
  filetypes = { 'python' },
  root_markers = {
    'pytest.ini',
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    '.git',
  },
}
