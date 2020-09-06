local configs = require 'nvim_lsp/configs'
local util = require 'nvim_lsp/util'

configs.scry = {
  default_config = {
    cmd = {'scry'},
    filetypes = {'crystal'},
    root_dir = function(fname)
      return util.root_pattern('shard.yml') or
        util.find_git_ancestor(fname) or
        util.path.dirname(fname)
    end
  },
  docs = {
      description = [[
https://github.com/crystal-lang-tools/scry

Crystal language server.
]],
      default_config = {
          root_dir = [[root_pattern('shard.yml', '.git') or dirname]]
      }
  }
}
