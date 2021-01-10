local configs = require 'lspconfig/configs'

local M = {
  util = require 'lspconfig/util';
}

M._root = {}

function M.available_servers()
  return vim.tbl_keys(configs)
end

function M.installable_servers()
  print("deprecated, see https://github.com/neovim/neovim/wiki/Following-HEAD")
end

-- Called from plugin/lspconfig.vim because it requires knowing that the last
-- script in scriptnames to be executed is lspconfig.
function M._root._setup()
  M._root.commands = {
    LspInstall = {
      function()
        print("deprecated, see https://github.com/neovim/neovim/wiki/Following-HEAD")
      end;
      "-nargs=?";
      "-complete=custom,v:lua.lsp_complete_installable_servers";
      description = '`:LspInstall {name}` installs a server under stdpath("cache")/lspconfig/{name}';
    };
    LspInstallInfo = {
      function()
        print("deprecated, see https://github.com/neovim/neovim/wiki/Following-HEAD")
      end;
      "-nargs=?";
      "-complete=custom,v:lua.lsp_complete_servers";
      description = 'Print installation info for {name} if one is specified, or all installable servers.';
    };
  };

  M.util.create_module_commands("_root", M._root.commands)
end

local mt = {}
function mt:__index(k)
  if configs[k] == nil and M.util.is_module_available('lspconfig/'..k) then
    require('lspconfig/'..k)
  end
  return configs[k]
end

return setmetatable(M, mt)
-- vim:et ts=2 sw=2
