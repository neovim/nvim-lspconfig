local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = "cssls"
local bin_name = "css-languageserver"

local installer = util.npm_installer {
  server_name = server_name;
  packages = { "vscode-css-languageserver-bin" };
  binaries = {bin_name};
}

local root_pattern = util.root_pattern("package.json")

configs[server_name] = {
  default_config = {
    cmd = {bin_name, "--stdio"};
    filetypes = {"css", "scss", "less"};
    root_dir = function(fname)
      return root_pattern(fname) or vim.loop.os_homedir()
    end;
    settings = {
      css = { validate = true },
      scss = { validate = true },
      less = { validate = true }
     };
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
https://github.com/vscode-langservers/vscode-css-languageserver-bin

`css-languageserver` can be installed via `:LspInstall cssls` or by yourself with `npm`:
```sh
npm install -g vscode-css-languageserver-bin
```
]];
    default_config = {
      root_dir = [[root_pattern("package.json")]];
    };
  };
}

configs[server_name].install = installer.install
configs[server_name].install_info = installer.info
-- vim:et ts=2 sw=2
