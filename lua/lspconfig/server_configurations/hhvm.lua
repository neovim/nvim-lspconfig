local util = require 'lspconfig.util'

local bin_name = 'hh_client'
local cmd = {bin_name, 'lsp'}

local description = [[
Language server for programs written in Hack
https://hhvm.com/
https://github.com/facebook/hhvm
See below for how to setup HHVM & typechecker:
https://docs.hhvm.com/hhvm/getting-started/getting-started
]]

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'php', 'hack' },
    root_dir = util.root_pattern '.hhconfig',
    settings = {},
  },
  docs = {
    description = description,
    default_config = {
      root_dir = [[root_pattern(".hhconfig")]],
    },
  },
}
