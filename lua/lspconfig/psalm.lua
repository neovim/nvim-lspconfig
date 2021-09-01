local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = 'psalm'
local bin_name = 'bin/psalm-language-server'

configs[server_name] = {
  default_config = {
    cmd = { bin_name },
    filetypes = { 'php' },
    root_dir = function(pattern)
      local cwd = vim.loop.cwd()
      local root = util.root_pattern('psalm.xml', 'composer.json', '.git')(pattern)
      -- prefer cwd if root is a descendant
      return util.path.is_descendant(cwd, root) and cwd or root
    end,
  },
  docs = {
    description = [[
https://psalm.dev/docs/running_psalm/language_server/

]],
    default_config = {
      cmd = { 'bin/psalm-language-server' },
      root_dir = [[root_pattern("psalm.xml", "composer.json", ".git")]],
    },
  },
}
