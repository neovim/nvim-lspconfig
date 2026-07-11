---@brief
---
--- https://fortitude.readthedocs.io/en/stable/
---
--- Fortitude is a Fortran linter built in Rust and inspired by (and build upon) Ruff
---
--- ```sh
--- # Install With uv:
--- uv tool install fortitude-lint@latest
---
--- # Install with pip:
--- pip install fortitude-lint
--- ```
---
--- **LSP is available in Fortitude `v0.8.0`.**
---
--- Refer to the [documentation](https://fortitude.readthedocs.io/en/stable/editors/) for more details.

---@type vim.lsp.Config
return {
  cmd = { 'fortitude', 'server' },
  filetypes = { 'fortran' },
  root_markers = {
    'fpm.toml',
    'fortitude.toml',
    '.fortitude.toml',
    '.git',
  },
  settings = {},
}
