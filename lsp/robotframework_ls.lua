---@brief
---
--- https://github.com/robocorp/robotframework-lsp
---
--- Language Server Protocol implementation for Robot Framework.
return {
  cmd = { 'robotframework_ls' },
  filetypes = { 'robot' },
  root_markers = { 'robotidy.toml', 'pyproject.toml', 'conda.yaml', 'robot.yaml', '.git' },
}
