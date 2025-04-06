local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'dart', 'language-server', '--protocol=lsp' },
    filetypes = { 'dart' },
    root_dir = util.root_pattern('pubspec.yaml'),
    init_options = {
      closingLabels = true,
      flutterOutline = true,
      onlyAnalyzeProjectsWithOpenFiles = true,
      outline = true,
      suggestFromUnimportedLibraries = true,
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

Language server for Flutter/Dart.
    ]],
  },
}
