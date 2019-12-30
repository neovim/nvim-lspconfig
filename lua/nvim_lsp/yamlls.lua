local skeleton = require 'nvim_lsp/skeleton'
local util = require 'nvim_lsp/util'
local lsp = vim.lsp

local server_name = "yamlls"
local bin_name = "yaml-language-server"

local installer = util.npm_installer {
  server_name = server_name;
  packages = {bin_name};
  binaries = {bin_name};
}

skeleton[server_name] = {
  default_config = util.utf8_config {
    cmd = {bin_name, "--stdio"};
    filetypes = {"yaml"};
    root_dir = util.root_pattern(".git", vim.fn.getcwd());
    log_level = lsp.protocol.MessageType.Warning;
    settings = {};
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
    vscode = "redhat.vscode-yaml";
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

skeleton[server_name].install = installer.install
skeleton[server_name].install_info = installer.info
-- vim:et ts=2 sw=2
