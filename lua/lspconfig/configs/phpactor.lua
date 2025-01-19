local util = require('lspconfig.util')

return {
  default_config = {
    cmd = { 'phpactor', 'language-server' },
    filetypes = { 'php' },
    root_dir = function(pattern)
      local cwd = vim.loop.cwd()
      local root = vim.fs.dirname(
        vim.fs.find({ 'composer.json', '.git', '.phpactor.json', '.phpactor.yml' }, { path = pattern, upward = true })[1]
      )

      -- prefer cwd if root is a descendant
      return util.path.is_descendant(cwd, root) and cwd or root
    end,
  },
  docs = {
    description = [[
https://github.com/phpactor/phpactor

Installation: https://phpactor.readthedocs.io/en/master/usage/standalone.html#global-installation
]],
  },
}
