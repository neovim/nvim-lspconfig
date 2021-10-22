local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local name = 'bsl'

configs[name] = {
  default_config = {
    filetypes = { 'bsl', 'os' },
    root_dir = util.path.dirname or util.find_git_ancestor,
  },
  docs = {
    description = [[
    Client to https://github.com/1c-syntax/bsl-language-server
    Which work with .bsl and .os files
    ]],
    default_config = {
      root_dir = [[root_pattern(".git") or bufdir]],
    },
  },
}
