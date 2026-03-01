---@brief
---
--- https://github.com/AJenbo/phpantom_lsp
---
--- Installation: https://github.com/AJenbo/phpantom_lsp/blob/main/docs/SETUP.md

---@type vim.lsp.Config
return {
  cmd = { 'phpantom_lsp' },
  filetypes = { 'php' },
  root_markers = { '.git', 'composer.json' },
}
