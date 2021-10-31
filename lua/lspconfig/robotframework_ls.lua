local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = 'robotframework_ls'

configs[server_name] = {
  default_config = {
    cmd = { 'robotframework_ls' },
    filetypes = { 'robot' },
    root_dir = function(fname)
      return util.root_pattern '.git'(fname) or util.path.dirname(fname)
    end,
  },
  docs = {
    description = [[
https://github.com/robocorp/robotframework-lsp

Language Server Protocol implementation for Robot Framework.
]],
    default_config = {
      root_dir = "vim's starting directory",
    },
  },
}
