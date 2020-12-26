local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = "html"
local bin_name = "html-languageserver"

local installer = util.npm_installer {
  server_name = server_name;
  packages = { "vscode-html-languageserver-bin" };
  binaries = {bin_name};
}

-- This is an ugly hack since the html-languageserver requires snippet support to be registered in capabilities for completion
-- https://github.com/vscode-langservers/vscode-html-languageserver/blob/3292e4cc7d1ac40d3de9a21bca5cc0dae6f7271e/src/htmlServer.ts#L152
local default_capabilities = vim.lsp.protocol.make_client_capabilities()
default_capabilities.textDocument.completion.completionItem.snippetSupport = true;
local root_pattern = util.root_pattern("package.json")

configs[server_name] = {
  default_config = {
    cmd = {bin_name, "--stdio"};
    filetypes = {"html"};
    capabilities = default_capabilities;
    root_dir = function(fname)
      return root_pattern(fname) or vim.loop.os_homedir()
    end;
    settings = {};
    init_options = {
      embeddedLanguages = { css= true, javascript= true },
      configurationSection = { 'html', 'css', 'javascript' },
    }

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
https://github.com/vscode-langservers/vscode-html-languageserver-bin

`html-languageserver` can be installed via `:LspInstall html` or by yourself with `npm`:
```sh
npm install -g vscode-html-languageserver-bin
```
]];
  };
}

configs[server_name].install = installer.install
configs[server_name].install_info = installer.info
-- vim:et ts=2 sw=2
