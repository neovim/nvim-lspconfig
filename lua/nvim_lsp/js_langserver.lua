vim.cmd('packadd nvim-lsp')

local configs = require 'nvim_lsp/configs'
local util = require 'nvim_lsp/util'
local lsp = vim.lsp

local server_name = "js_langserver"
local package_name = "js-langserver"
local bin_name = package_name

local installer = util.npm_installer {
  server_name = server_name;
  packages = {package_name};
  binaries = {bin_name};
}

configs[server_name] = {
  default_config = util.utf8_config {
    cmd = {bin_name, "--stdio"};
    filetypes = {"javascript", "javascriptreact", "javascript.jsx"};
    root_dir = util.root_pattern("package.json");
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
https://github.com/tbodt/js-langserver

`js-langserver` can be installed via `:LspInstall js-langserver` or by yourself with `npm`:
```sh
npm install -g js-langserver
```
]];
    default_config = {
      root_dir = [[root_pattern("package.json")]];
      on_init = [[function to handle changing offsetEncoding]];
      capabilities = [[default capabilities, with offsetEncoding utf-8]];
    };
  };
}

configs[server_name].install = installer.install
configs[server_name].install_info = installer.info

-- vim:et ts=2 sw=2
