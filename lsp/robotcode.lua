---@brief
---
--- https://robotcode.io
---
--- RobotCode - Language Server Protocol implementation for Robot Framework.

---@type vim.lsp.Config
return {
  cmd = { 'robotcode', 'language-server' },
  filetypes = { 'robot', 'resource' },
  root_markers = { 'robot.toml', 'pyproject.toml', 'Pipfile', '.git' },
  get_language_id = function(_, _)
    return 'robotframework'
  end,
}
