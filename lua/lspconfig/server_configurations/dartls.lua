local util = require 'lspconfig.util'

local bin_name = 'dart'
local cmd = { bin_name, 'language-server', '--protocol=lsp' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, 'language-server', '--protocol=lsp' }
end

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'dart' },
    root_dir = util.root_pattern 'pubspec.yaml',
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
      root_dir = [[root_pattern("pubspec.yaml")]],
    },
  },
}
