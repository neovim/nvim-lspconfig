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

---@type vim.lsp.Config
return {
  cmd = { 'futhark', 'lsp' },
  filetypes = { 'futhark', 'fut' },
  root_markers = { '.git' },
}
