local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = "jsonls"
local bin_name = "vscode-json-languageserver"

configs[server_name] = {
  default_config = {
    cmd = {bin_name, "--stdio"};
    filetypes = {"json"};
    root_dir = util.root_pattern(".git", vim.fn.getcwd());
  };
  docs = {
    -- this language server config is in VSCode built-in package.json
    package_json = "https://raw.githubusercontent.com/microsoft/vscode/master/extensions/json-language-features/package.json";
    description = [[
https://github.com/vscode-langservers/vscode-json-languageserver

vscode-json-languageserver, a language server for JSON and JSON schema

`vscode-json-languageserver` can be installed via `npm`:
```sh
npm install -g vscode-json-languageserver
```
]];
    default_config = {
      root_dir = [[root_pattern(".git", vim.fn.getcwd())]];
    };
  };
}

-- vim:et ts=2 sw=2
