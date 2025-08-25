---@brief
---
--- https://github.com/npezza93/ttags

---@type vim.lsp.Config
return {
  cmd = { 'ttags', 'lsp' },
  filetypes = { 'ruby', 'rust', 'javascript', 'haskell' },
  root_markers = { '.git' },
}
