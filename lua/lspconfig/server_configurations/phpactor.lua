local util = require 'lspconfig.util'

local workspace_markers = { 'composer.json', '.git' }

return {
  default_config = {
    cmd = { 'phpactor', 'language-server' },
    filetypes = { 'php' },
    root_dir = function(pattern)
      local cwd = vim.loop.cwd()
      local root = util.root_pattern(unpack(workspace_markers))(pattern)

      -- prefer cwd if root is a descendant
      return util.path.is_descendant(cwd, root) and cwd or root
    end,
  },
  docs = {
    description = [[
https://github.com/phpactor/phpactor

Installation: https://phpactor.readthedocs.io/en/master/usage/standalone.html#global-installation
]],
    default_config = {
      cmd = { 'phpactor', 'language-server' },
      workspace_markers = workspace_markers,
    },
  },
}
