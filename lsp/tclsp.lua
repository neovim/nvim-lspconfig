---@brief
---
--- https://github.com/nmoroze/tclint
---
--- `tclsp`, a language server for Tcl
---
--- `tclsp` can be installed via `pipx`:
--- ```sh
--- pipx install tclint
--- ```
---
--- Or via `pip`:
--- ```sh
--- pip install tclint
--- ```

---@type vim.lsp.Config
return {
  cmd = { 'tclsp' },
  filetypes = { 'tcl', 'sdc', 'xdc', 'upf' },
  root_markers = { 'tclint.toml', '.tclint', 'pyproject.toml', '.git' },
}
