---@brief
---
--- https://github.com/diku-dk/futhark
---
--- Futhark Language Server
---
--- This language server comes with the futhark compiler and is run with the command
--- ```
--- futhark lsp
--- ```
return {
  cmd = { 'futhark', 'lsp' },
  filetypes = { 'futhark', 'fut' },
  root_markers = { '.git' },
}
