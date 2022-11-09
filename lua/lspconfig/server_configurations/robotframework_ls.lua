local util = require 'lspconfig.util'

local workspace_markers = { 'robotidy.toml', 'pyproject.toml', '.git' }

return {
  default_config = {
    cmd = { 'robotframework_ls' },
    filetypes = { 'robot' },
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  docs = {
    description = [[
https://github.com/robocorp/robotframework-lsp

Language Server Protocol implementation for Robot Framework.
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
