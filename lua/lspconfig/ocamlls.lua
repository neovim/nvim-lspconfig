local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = "ocamlls"
local bin_name = "ocaml-language-server"

local installer = util.npm_installer {
  server_name = server_name;
  packages = { "ocaml-language-server" };
  binaries = { bin_name };
}

configs[server_name] = {
  default_config = {
    cmd = { bin_name, "--stdio" };
    filetypes = { "ocaml", "reason" };
    root_dir = util.root_pattern(".merlin", "package.json");
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
    description = [[
https://github.com/ocaml-lsp/ocaml-language-server

`ocaml-language-server` can be installed via `:LspInstall ocamlls` or by yourself with `npm`
```sh
npm install -g ocaml-langauge-server
```
    ]];
    default_config = {
      root_dir = [[root_pattern(".merlin", "package.json")]];
    };
  };
};
configs[server_name].install = installer.install
configs[server_name].install_info = installer.info
-- vim:et ts=2 sw=2
