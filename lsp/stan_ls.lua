---@brief
---
--- https://github.com/tomatitito/stan-language-server
---
--- Language server for the Stan probabilistic programming language.
---
---@type vim.lsp.Config
return {
  cmd = { 'stan-language-server', '--stdio' },
  filetypes = { 'stan' },
  root_markers = { '.git' },
  settings = {},
}
