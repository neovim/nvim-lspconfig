local util = require 'lspconfig.util'

local cmd = (
  vim.fn.has 'win32' == 1 and { 'cmd.exe', '/C', 'dart', 'language-server', '--protocol=lsp' }
  or { 'dart', 'language-server', '--protocol=lsp' }
)

local workspace_markers = { 'pubspec.yaml' }

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'dart' },
    root_dir = util.root_pattern(unpack(workspace_markers)),
    init_options = {
      onlyAnalyzeProjectsWithOpenFiles = true,
      suggestFromUnimportedLibraries = true,
      closingLabels = true,
      outline = true,
      flutterOutline = true,
    },
    settings = {
      dart = {
        completeFunctionCalls = true,
        showTodos = true,
      },
    },
  },
  docs = {
    description = [[
https://github.com/dart-lang/sdk/tree/master/pkg/analysis_server/tool/lsp_spec

Language server for dart.
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
