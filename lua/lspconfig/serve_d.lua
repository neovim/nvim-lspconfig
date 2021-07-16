local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

<<<<<<< HEAD
configs.serve_d = {
=======
configs.zls = {
>>>>>>> f8bd92f845a213649e6716e9202bcc94665fb127
  default_config = {
    cmd = { 'serve-d' },
    filetypes = { 'd' },
    root_dir = function(fname)
      return util.root_pattern('dub.json', 'dub.sdl', '.git')(fname)
    end,
  },
  docs = {
    description = [[
           https://github.com/Pure-D/serve-d

           `Microsoft language server protocol implementation for D using workspace-d.`
        ]],
    default_config = {
      root_dir = [[util.root_pattern("dub.json", "dub.sdl", ".git") or current_file_dirname]],
    },
  },
}
