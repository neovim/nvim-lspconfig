---@brief
---
--- https://github.com/joshuadavidthomas/django-language-server
---
--- `djls`, a language server for the Django web framework.

---@type vim.lsp.Config
return {
  cmd = { 'djls', 'serve' },
  filetypes = { 'htmldjango', 'html', 'python' },
  root_markers = { 'manage.py', 'pyproject.toml', '.git' },
}
