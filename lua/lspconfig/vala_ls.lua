local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.vala_ls = {
  default_config = {
    cmd = {'vala-language-server'},
    filetypes = {'vala', 'genie'},
    root_dir = function(fname)
      return util.root_pattern("meson.build")(fname)
        or util.find_git_ancestor(fname)
    end,
  },
  docs = {
    description = 'https://github.com/benwaffle/vala-language-server',
    default_config = {
      root_dir = [[root_pattern("meson.build", ".git")]]
    },
  },
}

-- vim:et ts=2 sw=2
