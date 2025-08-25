---@brief
---
--- https://github.com/fourdigits/django-template-lsp
---
--- `djlsp`, a language server for Django templates.

---@type vim.lsp.Config
return {
  cmd = { 'djlsp' },
  filetypes = { 'html', 'htmldjango' },
  root_markers = { '.git' },
  settings = {},
}
