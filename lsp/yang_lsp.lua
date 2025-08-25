---@brief
---
--- https://github.com/TypeFox/yang-lsp
---
--- A Language Server for the YANG data modeling language.

---@type vim.lsp.Config
return {
  cmd = { 'yang-language-server' },
  filetypes = { 'yang' },
  root_markers = { '.git' },
}
