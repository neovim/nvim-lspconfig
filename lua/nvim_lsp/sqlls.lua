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
    cmd = {bin_name, "up", "--method", "stdio"};
    filetypes = {"sql", "mysql"};
    root_dir = function(fname)
      return root_pattern(fname)
              or vim.fn.getcwd()
              or vim.loop.os_homedir()
    end;
  };
  docs = {
    package_json = "https://raw.githubusercontent.com/joe-re/sql-language-server/release/package.json";
    description = [[
      https://github.com/joe-re/sql-language-server

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

