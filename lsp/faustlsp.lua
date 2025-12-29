---@brief
---
--- https://github.com/carn181/faustlsp
---
--- Faust language server protocol (LSP) support.

---@type vim.lsp.Config
return {
  cmd = { 'faustlsp' },
  filetypes = { 'faust' },
  workspace_required = true,
  root_markers = { '.faustcfg.json' },
}
