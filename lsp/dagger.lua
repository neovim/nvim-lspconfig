---@brief
---
--- https://github.com/dagger/cuelsp
---
--- Dagger's lsp server for cuelang.
return {
  cmd = { 'cuelsp' },
  filetypes = { 'cue' },
  root_markers = { 'cue.mod', '.git' },
}
