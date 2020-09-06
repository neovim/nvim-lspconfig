local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = "sqlls"
local bin_name = "sql-language-server"

local installer = util.npm_installer {
  server_name = server_name;
  packages = { "sql-language-server" };
  binaries = {bin_name};
}

local root_pattern = util.root_pattern(".sqllsrc.json")

configs[server_name] = {
  default_config = {
    filetypes = {"sql", "mysql"};
    root_dir = function(fname)
      return root_pattern(fname) or vim.loop.os_homedir()
    end;
    settings = {};
  };
  on_new_config = function(config)
    local install_info = installer.info();
    local P = util.path.join
    if install_info.is_installed then
       local bin_ex = P{install_info.bin_dir, bin_name}
       config.cmd = {bin_ex, "up", "--method", "stdio"}
    end
  end;
  docs = {
    description = [[
https://github.com/joe-re/sql-language-server

`cmd` value is **not set** by default. An installer is provided via the `:LspInstall` command that uses the *nvm_lsp node_modules* directory to find the sql-language-server executable. The `cmd` value can be overriden in the `setup` table;

```lua
require'lspconfig'.sqlls.setup{
  cmd = {"path/to/command", "up", "--method", "stdio"};
  ...
}
```

This LSP can be installed via `:LspInstall sqlls` or with `npm`. If using LspInstall, run `:LspInstallInfo sqlls` to view installation paths. Find further instructions on manual installation of the sql-language-server at [joe-re/sql-language-server](https://github.com/joe-re/sql-language-server).
<br>
    ]];
  };
}

configs[server_name].install = installer.install
configs[server_name].install_info = installer.info
-- vim:et ts=2 sw=2
