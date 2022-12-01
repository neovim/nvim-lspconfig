local util = require 'lspconfig.util'

local workspace_markers = { 'ols.json', '.git' }

return {
  default_config = {
    cmd = { 'ols' },
    filetypes = { 'odin' },
    root_dir = util.root_pattern(unpack(workspace_markers)),
    single_file_support = true,
  },
  docs = {
    description = [[
           https://github.com/DanielGavin/ols

           `Odin Language Server`.
        ]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
