local skeleton = require 'nvim_lsp/skeleton'
local util = require 'nvim_lsp/util'
local lsp = vim.lsp

local server_name = "intelephense"
local bin_name = "intelephense"

local installer = util.npm_installer {
  server_name = server_name;
  packages = { "intelephense" };
  binaries = {bin_name};
}

skeleton[server_name] = {
  default_config = util.utf8_config {
    cmd = {bin_name, "--stdio"};
    filetypes = {"php"};
    root_dir = function (pattern)
      local cwd  = vim.loop.cwd();
      local root = util.root_pattern("composer.json", ".git")(pattern);

      -- prefer cwd if root is a descendant
      return util.path.is_descendant(cwd, root) and cwd or root;
    end;
    log_level = lsp.protocol.MessageType.Warning;
    settings = {
      intelephense = {
        environment = {
          documentRoot = "";
        };
      };
    };
    init_options = {
      licenceKey = "";
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
https://intelephense.com/

`intelephense` can be installed via `:LspInstall intelephense` or by yourself with `npm`: 
```sh
npm install -g intelephense
```
]];
    default_config = {
      root_dir = [[root_pattern("composer.json", ".git")]];
      on_init = [[function to handle changing offsetEncoding]];
      capabilities = [[default capabilities, with offsetEncoding utf-8]];
      init_options = [[{
        licenceKey = ""
      }]];
    };
  };
}

skeleton[server_name].install = installer.install
skeleton[server_name].install_info = installer.info
-- vim:et ts=2 sw=2

