local skeleton = require 'nvim_lsp/skeleton'
local util = require 'nvim_lsp/util'
local lsp = vim.lsp

local server_name = "bashls"
local bin_name = "bash-language-server"

local installer = util.npm_installer {
  server_name = server_name;
  packages = { "bash-language-server" };
  binaries = {bin_name};
}

skeleton[server_name] = {
  default_config = {
    cmd = {"bash-language-server", "start"};
    filetypes = {"sh"};
    root_dir = vim.loop.os_homedir;
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
  -- on_attach = function(client, bufnr) end;
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

skeleton[server_name].install = installer.install
skeleton[server_name].install_info = installer.info
-- vim:et ts=2 sw=2
