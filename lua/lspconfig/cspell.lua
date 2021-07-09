local configs = require "lspconfig/configs"
local util = require "lspconfig/util"

local server_name = "cspell"

configs[server_name] = {
  default_config = {
    cmd = {
      "/bin/node",
      "/home/zethra/Downloads/build/extension/server/server.js",
      "--stdio",
    },
    filetypes = { "text" },
    root_dir = function(fname)
      return util.root_pattern ".git"(fname) or util.path.dirname(fname)
    end,
  },

  docs = {
    description = [[
https://github.com/mattn/efm-langserver

General purpose Language Server that can use specified error message format generated from specified command.
]],
    default_config = {
      root_dir = [[util.root_pattern(".git")(fname) or util.path.dirname(fname)]],
    },
  },
}
-- vim:et ts=2 sw=2
