---@brief
---
--- https://github.com/ponylang/pony-language-server
---
--- Language server for the Pony programming language

---@type vim.lsp.Config
return {
  cmd = { 'pony-lsp' },
  filetypes = { 'pony' },
  root_markers = { 'corral.json', '.git' },
}
