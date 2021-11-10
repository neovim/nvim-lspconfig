local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.esbonio = {
  default_config = {
    cmd = { 'esbonio' },
    filetypes = { 'rst' },
    root_dir = function(fname)
      local root_files = {
        'config.py',
        '.git'
      }
      return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
    end,
  },
  docs = {
    description = [[
https://github.com/swyddfa/esbonio
    
A Language Server that aims to make it easier to work with Sphinx documentation projects in editors that support it.
    ]],
  },
}
