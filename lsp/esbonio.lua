---@brief
---
--- https://github.com/swyddfa/esbonio
---
--- Esbonio is a language server for [Sphinx](https://www.sphinx-doc.org/en/master/) documentation projects.
--- The language server can be installed as a standalone tool with uv or pipx.
---
--- ```
--- uv tool install esbonio
--- ```
---
--- Configure the Python environment and Sphinx build command for each project in `pyproject.toml`.
---
--- ```toml
--- [tool.esbonio.sphinx]
--- pythonCommand = ["uv", "run", "python"]
--- buildArguments = ["-M", "dirhtml", ".", "${defaultBuildDir}"]
--- ```
---
--- The same options can be supplied through LSP settings if a project does not use `pyproject.toml`.
---
--- ```lua
--- vim.lsp.config('esbonio', {
---   settings = {
---     esbonio = {
---       sphinx = {
---         pythonCommand = { 'uv', 'run', 'python' },
---         buildCommand = { 'sphinx-build', '-M', 'dirhtml', '.', '${defaultBuildDir}' },
---       },
---     },
---   },
--- })
--- ```
---
--- See the [Esbonio documentation](https://docs.esbon.io/en/release/integrating/howto/nvim.html)
--- for the full configuration reference and additional Neovim integration examples.

---@type vim.lsp.Config
return {
  cmd = { 'esbonio', 'server' },
  filetypes = { 'rst' },
  root_markers = { 'conf.py', '.git' },
}
