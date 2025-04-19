---@brief
---
--- https://github.com/nushell/nushell
---
--- Nushell built-in language server.
return {
  cmd = { 'nu', '--lsp' },
  filetypes = { 'nu' },
  root_markers = { '.git' },
}
