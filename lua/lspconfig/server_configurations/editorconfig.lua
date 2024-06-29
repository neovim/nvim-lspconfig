local util = require 'lspconfig.util'

local root_files = { '.editorconfig' }
return {
  default_config = {
    cmd = { 'ecls', '--stdio' },
    filetypes = { 'editorconfig' },
    root_dir = function(fname)
      return util.root_pattern(unpack(root_files))(fname)
    end,
    init_options = {
      buildDirectory = 'build',
    },
  },
  docs = {
    description = [[
https://github.com/Lilja/ecls
Editorconfig language server
]],
    default_config = {
      root_dir = [[root_pattern('.editorconfig')]],
    },
  },
}
