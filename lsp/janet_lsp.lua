---@brief
---
--- https://github.com/CFiggers/janet-lsp
---
--- A Language Server Protocol implementation for Janet.
return {
  cmd = {
    'janet-lsp',
    '--stdio',
  },
  filetypes = { 'janet' },
  root_markers = { 'project.janet', '.git' },
}
