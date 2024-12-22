local util = require 'lspconfig.util'

local function is_descendant(root, path)
  return vim.startswith(vim.fs.normalize(path), vim.fs.normalize(root))
end

return {
  default_config = {
    cmd = { 'phpactor', 'language-server' },
    filetypes = { 'php' },
    root_dir = function(pattern)
      local cwd = vim.loop.cwd()
      local root = util.root_pattern('composer.json', '.git', '.phpactor.json', '.phpactor.yml')(pattern)

      -- prefer cwd if root is a descendant
      return is_descendant(cwd, root) and cwd or root
    end,
  },
  docs = {
    description = [[
https://github.com/phpactor/phpactor

Installation: https://phpactor.readthedocs.io/en/master/usage/standalone.html#global-installation
]],
  },
}
