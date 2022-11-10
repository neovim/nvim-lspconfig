local util = require 'lspconfig.util'

local workspace_markers = { '.git' }
return {
  default_config = {
    cmd = { 'qmlls' },
    filetypes = { 'qmljs' },
    root_dir = util.root_pattern(unpack(workspace_markers)),
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/qt/qtdeclarative

LSP implementation for QML (autocompletion, live linting, etc. in editors),
        ]],
    workspace_markers = workspace_markers,
  },
}
