local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = "jsonls"
local bin_name = "vscode-json-languageserver"

local installer = util.npm_installer {
  server_name = server_name;
  packages = {bin_name};
  binaries = {bin_name};
}

configs[server_name] = {
  default_config = {
    cmd = {bin_name, "--stdio"};
    filetypes = {"json"};
    root_dir = util.root_pattern(".git", vim.fn.getcwd());
  };
  on_new_config = function(new_config)
    local install_info = installer.info()
    if install_info.is_installed then
      if type(new_config.cmd) == 'table' then
        -- Try to preserve any additional args from upstream changes.
        new_config.cmd[1] = install_info.binaries[bin_name]
      else
        new_config.cmd = {install_info.binaries[bin_name]}
      end
    end
  end;
  docs = {
    -- this language server config is in VSCode built-in package.json
    package_json = "https://raw.githubusercontent.com/microsoft/vscode/master/extensions/json-language-features/package.json";
    description = [[
https://github.com/vscode-langservers/vscode-json-languageserver

vscode-json-languageserver, a language server for JSON and JSON schema

`vscode-json-languageserver` can be installed via `:LspInstall jsonls` or by yourself with `npm`:
```sh
npm install -g vscode-json-languageserver
```
]];
    default_config = {
      root_dir = [[root_pattern(".git", vim.fn.getcwd())]];
    };
  };
}

configs[server_name].install = installer.install
configs[server_name].install_info = installer.info
-- vim:et ts=2 sw=2
