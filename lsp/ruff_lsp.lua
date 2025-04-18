---@brief
---
--- https://github.com/astral-sh/ruff-lsp
---
--- A Language Server Protocol implementation for Ruff, an extremely fast Python linter and code transformation tool, written in Rust. It can be installed via pip.
---
--- ```sh
--- pip install ruff-lsp
--- ```
---
--- Extra CLI arguments for `ruff` can be provided via
---
--- ```lua
--- vim.lsp.config('ruff_lsp', {
---   init_options = {
---     settings = {
---       -- Any extra CLI arguments for `ruff` go here.
---       args = {},
---     }
---   }
--- })
--- ```
return {
  cmd = { 'ruff-lsp' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'ruff.toml', '.git' },
  settings = {},
}
