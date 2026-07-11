---@brief
---
--- https://github.com/hylo-lang/hylo-language-server
---
--- A language server for the Hylo programming language.

---@type vim.lsp.Config
return {
  cmd = { 'hylo-language-server', '--stdio' },
  filetypes = { 'hylo' },
  root_markers = { '.git' },
  settings = {},
}
