local nvim_lsp = require 'nvim_lsp'
local configs = require 'nvim_lsp/configs'
local lsp = vim.lsp

local server_name = "dartls"
local bin_name = "dart"
local dart_sdk_path = os.getenv("DART_SDK")

configs[server_name] = {
  default_config = {
    cmd = {bin_name, dart_sdk_path .. "/bin/snapshots/analysis_server.dart.snapshot", "--lsp"};
    filetypes = {"dart"};
    root_dir = nvim_lsp.util.root_pattern("pubspec.yaml");
    log_level = lsp.protocol.MessageType.Warning;
    init_options = {
      onlyAnalyzeProjectsWithOpenFiles = "false",
      suggestFromUnimportedLibraries = "true",
      closingLabels = "true",
      outline = "true",
      fluttreOutline= "false"
    };
    settings = {};
  };
  docs = {
  	package_json = "https://raw.githubusercontent.com/Dart-Code/Dart-Code/master/package.json";
    description = [[
https://github.com/dart-lang/sdk/tree/master/pkg/analysis_server/tool/lsp_spec

Language server for Dart.
]];
    default_config = {
      root_dir = [[root_pattern("pubspec.yaml")]];
    };
  };
};


configs[server_name].install_info = function()
  return {
    is_installed = dart_sdk_path ~= nil
  }
end
