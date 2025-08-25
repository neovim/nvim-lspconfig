---@brief
---
--- https://github.com/polarmutex/beancount-language-server#installation
---
--- See https://github.com/polarmutex/beancount-language-server#configuration for configuration options

---@type vim.lsp.Config
return {
  cmd = { 'beancount-language-server', '--stdio' },
  filetypes = { 'beancount', 'bean' },
  root_markers = { '.git' },
  init_options = {},
}
