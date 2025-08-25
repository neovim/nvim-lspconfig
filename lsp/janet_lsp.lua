---@brief
---
--- https://github.com/CFiggers/janet-lsp
---
--- A Language Server Protocol implementation for Janet.

---@type vim.lsp.Config
return {
  cmd = {
    'janet-lsp',
    '--stdio',
  },
  filetypes = { 'janet' },
  root_markers = { 'project.janet', '.git' },
}
