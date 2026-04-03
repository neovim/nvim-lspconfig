---@brief
---
--- https://robotcode.io
---
--- RobotCode - Language Server Protocol implementation for Robot Framework.

local venv = os.getenv('VIRTUAL_ENV')

---@type vim.lsp.Config
return {
  cmd = { 'robotcode', 'language-server' },
  filetypes = { 'robot', 'resource' },
  root_markers = { 'robot.toml', 'pyproject.toml', 'Pipfile', '.git' },
  cmd_env = venv and { PYTHONPATH = string.gsub(vim.fn.glob(venv .. '/lib/python*/site-packages'), '\n', ':') } or nil,
  get_language_id = function(_, _)
    return 'robotframework'
  end,
}
