---@brief
---
--- https://github.com/s0cks/task-lsp
---
--- A Taskfile lsp written in Go

---@type vim.lsp.Config
return {
  cmd = { 'taskfile-lsp' },
  filetypes = { 'yaml.taskfile', 'taskfile' },
  root_markers = { '.git', 'Taskfile.yaml', 'Taskfile.yml' },
}
