local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = "yamlls"
local bin_name = "yaml-language-server"

local installer = util.npm_installer {
  server_name = server_name;
  packages = {bin_name};
  binaries = {bin_name};
}

configs[server_name] = {
  default_config = {
    cmd = {bin_name, "--stdio"};
    filetypes = {"yaml"};
    root_dir = util.root_pattern(".git", vim.fn.getcwd());
  };
  on_new_config = function(new_config)
    local install_info = installer.info()
    if install_info.is_installed then
      if type(new_config.cmd) == 'table' then
        new_config.cmd[1] = install_info.binaries[bin_name]
      else
        new_config.cmd = {install_info.binaries[bin_name]}
      end
    end
  end;
  docs = {
    package_json = "https://raw.githubusercontent.com/redhat-developer/vscode-yaml/master/package.json";
    description = [[
https://github.com/redhat-developer/yaml-language-server

`yaml-language-server` can be installed via `:LspInstall yamlls` or by yourself with `npm`:
```sh
npm install -g yaml-language-server
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
