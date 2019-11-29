local skeleton = require 'nvim_lsp/skeleton'
local util = require 'nvim_lsp/util'
local lsp = vim.lsp

local server_name = "dockerls"
local bin_name = "docker-language-server"

local installer = util.npm_installer {
  server_name = server_name;
  packages = { "docker-language-server-nodejs" };
  binaries = {bin_name};
}

skeleton[server_name] = {
  default_config = {
    cmd = {bin_name, "--stdio"};
    filetypes = {"Dockerfile", "dockerfile"};
    root_dir = util.root_pattern("Dockerfile");
    log_level = lsp.protocol.MessageType.Warning;
    settings = {};
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
    description = [[
https://github.com/rcjsuen/dockerfile-language-server-nodejs

`dockerfile-language-server` can be installed via `:LspInstall tsserver` or by yourself with `npm`: 
```sh
npm install -g docker-language-server-nodejs
```
    ]];
    default_config = {
      root_dir = [[root_pattern("Dockerfile")]];
    };
  };
};

skeleton[server_name].install = installer.install
skeleton[server_name].install_info = installer.info
-- vim:et ts=2 sw=2

