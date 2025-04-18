---@brief
---
--- https://templ.guide
---
--- The official language server for the templ HTML templating language.
return {
  cmd = { 'templ', 'lsp' },
  filetypes = { 'templ' },
  root_markers = { 'go.work', 'go.mod', '.git' },
}
