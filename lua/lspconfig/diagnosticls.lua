local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = "diagnosticls"
local bin_name = "diagnostic-languageserver"

local installer = util.npm_installer {
  server_name = server_name;
  packages = { bin_name };
  binaries = { bin_name };
}

configs[server_name] = {
  default_config = {
    cmd = {bin_name, "--stdio"},
    filetypes = {},
    root_dir = util.path.dirname,
  },
  on_new_config = function(new_config)
    local install_info = installer.info()
    if install_info.is_installed then
      if type(new_config.cmd) == 'table' then
        -- Try to preserve any additional args from upstream changes.
        new_config.cmd[1] = install_info.binaries[bin_name]
      else
        new_config.cmd = {install_info.binaries[bin_name], "--stdio"}
      end
    end
  end;
  docs = {
    description = [[
https://github.com/iamcco/diagnostic-languageserver

Diagnostic language server integrate with linters.
]];
    default_config = {
      filetypes = "Empty by default, override to add filetypes",
      root_dir = "Vim's starting directory";
      init_options = "Configuration from https://github.com/iamcco/diagnostic-languageserver#config--document";
    };
  };
}

configs[server_name].install = installer.install
configs[server_name].install_info = installer.info
