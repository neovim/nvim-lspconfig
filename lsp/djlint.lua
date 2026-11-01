---@brief
---
--- https://github.com/djlint/djLint
---
--- Linter and formatter for HTML templates. Needs djLint 1.49 or newer.
---
--- ```sh
--- pip install djlint
--- ```
---
--- See the [settings](https://djlint.com/docs/integrations/#settings).

---@type vim.lsp.Config
return {
  cmd = { 'djlint', '--lsp' },
  filetypes = { 'html', 'htmldjango', 'jinja', 'jinja.html', 'handlebars', 'liquid', 'gotmpl' },
  root_markers = { 'pyproject.toml', 'djlint.toml', '.djlint.toml', '.djlintrc', '.git' },
}
