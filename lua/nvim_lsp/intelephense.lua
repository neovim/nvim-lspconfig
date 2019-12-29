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
        storagePath = Optional absolute path to storage dir. Defaults to os.tmpdir().
        globalStoragePath = Optional absolute path to a global storage dir. Defaults to os.homedir().
        licenceKey = Optional licence key or absolute path to a text file containing the licence key.
        clearCache = Optional flag to clear server state. State can also be cleared by deleting {storagePath}/intelephense
        -- See https://github.com/bmewburn/intelephense-docs#initialisation-options
      }]];
      settings = [[{
        intelephense = {
          files = {
            maxSize = 1000000;
          };
        };
        -- See https://github.com/bmewburn/intelephense-docs#configuration-options
      }]];
    };
  };
}

skeleton[server_name].install = installer.install
skeleton[server_name].install_info = installer.info
-- vim:et ts=2 sw=2
