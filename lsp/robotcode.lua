---@brief
---
--- https://robotcode.io
---
--- RobotCode - Language Server Protocol implementation for Robot Framework.

local venv = os.getenv('VIRTUAL_ENV')
local iswin = vim.fn.has('win32') == 1

--- Returns the "site-packages" dir(s) of the given venv, as a $PYTHONPATH value.
local function site_packages(path)
  -- Windows venvs keep site-packages in "Lib/", not in "lib/python<version>/".
  local pattern = iswin and '/Lib/site-packages' or '/lib/python*/site-packages'
  local sep = iswin and ';' or ':'
  return (vim.fn.glob(vim.fs.normalize(path) .. pattern):gsub('\n', sep))
end

---@type vim.lsp.Config
return {
  cmd = { 'robotcode', 'language-server' },
  filetypes = { 'robot' },
  root_markers = { 'robot.toml', 'pyproject.toml', 'Pipfile', '.git' },
  cmd_env = venv and { PYTHONPATH = site_packages(venv) } or nil,
  get_language_id = function(_, _)
    return 'robotframework'
  end,
}
