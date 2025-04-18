---@brief
---
--- https://github.com/mistweaverco/kulala-ls
---
--- A minimal language server for HTTP syntax.
return {
  cmd = { 'kulala-ls', '--stdio' },
  filetypes = { 'http' },
  root_markers = { '.git' },
}
