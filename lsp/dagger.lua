---@brief
---
--- https://github.com/dagger/cuelsp
---
--- Dagger's lsp server for cuelang.

---@type vim.lsp.Config
return {
  cmd = { 'cuelsp' },
  filetypes = { 'cue' },
  root_markers = { 'cue.mod', '.git' },
}
