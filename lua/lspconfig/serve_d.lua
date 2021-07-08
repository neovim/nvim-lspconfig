local configs = require "lspconfig/configs"
local util = require "lspconfig/util"

local server_name = "serve_d"

configs[server_name] = {
  default_config = {
    cmd = { "serve-d" },
    filetypes = { "d" },
    root_dir = util.root_pattern("dub.json", "dub.sdl", ".git"),
  },
  docs = {
    description = [[
https://github.com/Pure-D/serve-d

D langauge server
]],
    default_config = {
      root_dir = [[util.root_pattern("dub.json", "dub.sdl", ".git")]],
    },
  },
}

-- vim:et ts=2 sw=2
