local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'robotframework_ls' },
    filetypes = { 'robot' },
    root_dir = function(fname)
      return util.root_pattern('robotidy.toml', 'pyproject.toml', 'conda.yaml', 'robot.yaml')(fname)
        or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/robocorp/robotframework-lsp

Language Server Protocol implementation for Robot Framework.
]],
  },
}
