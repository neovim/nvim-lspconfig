-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- This config is DEPRECATED.
-- Use the configs in `lsp/` instead (requires Nvim 0.11).
--
-- ALL configs in `lua/lspconfig/configs/` will be DELETED.
-- They exist only to support Nvim 0.10 or older.
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'robotcode', 'language-server' },
    filetypes = { 'robot', 'resource' },
    root_dir = util.root_pattern('robot.toml', 'pyproject.toml', 'Pipfile', '.git'),
    single_file_support = true,
    get_language_id = function(_, _)
      return 'robotframework'
    end,
  },
  docs = {
    description = [[
https://robotcode.io

RobotCode - Language Server Protocol implementation for Robot Framework.
]],
    default_config = {
      root_dir = "util.root_pattern('robot.toml', 'pyproject.toml', 'Pipfile')(fname) or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])",
      settings = {},
    },
  },
}
