local configs = require 'nvim_lsp/configs'
local util = require 'nvim_lsp/util'

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
    package_json = "https://raw.githubusercontent.com/joe-re/sql-language-server/release/package.json";
    description = [[
      https://github.com/joe-re/sql-language-server

      `cmd` value is **not set** by default. An installer is provided via this `:LspInstall` that uses the 
       nvm_lsp node_modules directory to find the executable. The `cmd` value can be overriden in `setup`;

             
      ```lua
      require'nvim_lsp'.sqlls.setup{
        cmd = {"path/to/command", "up", "--method", "stdio"};
        ...
      }
      ```

      Find further instructions on manual installation of the sql-language-server lsp at [joe-re/sql-language-server](https://github.com/joe-re/sql-language-server).

      `sql-language-server` can be installed via `:LspInstall sqlls` or by yourself with `npm`:
      ```sh
      npm install -g sql-language-server
      ```
    ]];
  };
}

configs[server_name].install = installer.install
configs[server_name].install_info = installer.info
-- vim:et ts=2 sw=2

