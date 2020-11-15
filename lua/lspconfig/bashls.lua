local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = "bashls"
local bin_name = "bash-language-server"

local installer = util.npm_installer {
  server_name = server_name;
  packages = { "bash-language-server" };
  binaries = {bin_name};
}

configs[server_name] = {
  default_config = {
    cmd = {"bash-language-server", "start"};
    filetypes = {"sh"};
    root_dir = util.path.dirname;
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
https://github.com/mads-hartmann/bash-language-server

Language server for bash, written using tree sitter in typescript.
]];
    default_config = {
      root_dir = "vim's starting directory";
    };
  };
};

configs[server_name].install = installer.install
configs[server_name].install_info = installer.info
-- vim:et ts=2 sw=2
