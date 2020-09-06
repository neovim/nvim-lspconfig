local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = "dockerls"
local bin_name = "docker-langserver"

local installer = util.npm_installer {
  server_name = server_name;
  packages = { "dockerfile-language-server-nodejs" };
  binaries = {bin_name};
}

configs[server_name] = {
  default_config = {
    cmd = {bin_name, "--stdio"};
    filetypes = {"Dockerfile", "dockerfile"};
    root_dir = util.root_pattern("Dockerfile");
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

`docker-langserver` can be installed via `:LspInstall dockerls` or by yourself with `npm`:
```sh
npm install -g dockerfile-language-server-nodejs
```
    ]];
    default_config = {
      root_dir = [[root_pattern("Dockerfile")]];
    };
  };
};

configs[server_name].install = installer.install
configs[server_name].install_info = installer.info
-- vim:et ts=2 sw=2
