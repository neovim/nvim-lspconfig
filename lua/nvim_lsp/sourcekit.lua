local configs = require 'nvim_lsp/configs'
local util = require 'nvim_lsp/util'

configs.sourcekit = {
  default_config = {
    cmd = {"xcrun", "sourcekit-lsp"};
    filetypes = {"swift"};
    root_dir = util.root_pattern("Package.swift", ".git")
  };
  -- on_new_config = function(new_config) end;
  -- on_attach = function(client, bufnr) end;
  docs = {
    package_json = "https://github.com/apple/sourcekit-lsp/blob/master/Editors/vscode/package.json";
    description = [[
https://github.com/apple/sourcekit-lsp

Language server for Swift and C/C++/Objective-C.
    ]];
    default_config = {
      root_dir = [[root_pattern("Package.swift", ".git")]];
    };
  };
};

-- vim:et ts=2 sw=2
