local configs = require 'lspconfig/configs'

local M = {
  util = require 'lspconfig/util';
}

function M.available_servers()
  return vim.tbl_keys(configs)
end

function M.installable_servers()
  local res = {}
  for k, v in pairs(configs) do
    if v.install then table.insert(res, k) end
  end
  return res
end

M._root = {}
-- Called from plugin/lspconfig.vim because it requires knowing that the last
-- script in scriptnames to be executed is lspconfig.
function M._root._setup()
  M._root.commands = {
    LspInstall = {
      function(name)
        if configs[name] == nil then
          pcall(require('lspconfig/'..name))
        end
        local config = configs[name]
        if not config then
          return print("Invalid server name:", name)
        end
        if not config.install then
          return print(name, "can't be automatically installed (yet)")
        end
        if config.install_info().is_installed then
          return print(name, "is already installed")
        end
        config.install()
      end;
      "-nargs=1";
      "-complete=custom,v:lua.lsp_complete_installable_servers";
      description = '`:LspInstall {name}` installs a server under stdpath("cache")/lspconfig/{name}';
    };
    LspInstallInfo = {
      function(name)
        if name == nil then
          local res = {}
          for k, v in pairs(configs) do
            if v.install_info then
              res[k] = v.install_info()
            end
          end
          return print(vim.inspect(res))
        end
        if configs[name] == nil then
          pcall(require('lspconfig/'..name))
        end
        local config = configs[name]
        if not config then
          return print("Invalid server name:", name)
        end
        return print(vim.inspect(config.install_info()))
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
  if configs[k] == nil then
    require('lspconfig/'..k)
  end
  return configs[k]
end

return setmetatable(M, mt)
-- vim:et ts=2 sw=2
