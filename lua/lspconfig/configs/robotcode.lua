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
      root_dir = "util.root_pattern('robot.toml', 'pyproject.toml', 'Pipfile')(fname) or util.find_git_ancestor(fname)",
      settings = {},
    },
  },
}
