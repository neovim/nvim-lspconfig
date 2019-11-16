local skeleton = require 'nvim_lsp/skeleton'
require 'nvim_lsp/bashls'
require 'nvim_lsp/clangd'
require 'nvim_lsp/elmls'
require 'nvim_lsp/gopls'
require 'nvim_lsp/hie'
require 'nvim_lsp/pyls'
require 'nvim_lsp/texlab'
require 'nvim_lsp/tsserver'

local M = {
  util = require 'nvim_lsp/util';
}

function M.available_servers()
  return vim.tbl_keys(skeleton)
end

function M.installable_servers()
  local res = {}
  for k, v in pairs(skeleton) do
    if v.install then table.insert(res, k) end
  end
  return res
end

M._root = {}
-- Called from plugin/nvim_lsp.vim because it requires knowing that the last
-- script in scriptnames to be executed is nvim_lsp.
function M._root._setup()
  local snr = tonumber(table.remove(vim.split(vim.fn.execute("scriptnames"), '\n')):match("^%s*(%d+)"))
  local function sid(s)
    return string.format("<SNR>%d_%s", snr, s)
  end

  M._root.commands = {
    LspInstall = {
      function(name)
        local template = skeleton[name]
        if not template then
          return print("Invalid server name:", name)
        end
        if not template.install then
          return print(name, "can't be automatically installed (yet)")
        end
        if template.install_info().is_installed then
          return print(name, "is already installed")
        end
        template.install()
      end;
      "-nargs=1";
      "-complete=custom,"..sid("complete_installable_server_names");
      description = '`:LspInstall {name}` installs a server under stdpath("cache")/nvim_lsp/{name}';
    };
    LspInstallInfo = {
      function(name)
        if name == nil then
          local res = {}
          for k, v in pairs(skeleton) do
            if v.install_info then
              res[k] = v.install_info()
            end
          end
          return print(vim.inspect(res))
        end
        local template = skeleton[name]
        if not template then
          return print("Invalid server name:", name)
        end
        return print(vim.inspect(template.install_info()))
      end;
      "-nargs=?";
      "-complete=custom,"..sid("complete_installable_server_names");
      description = 'Print installation info for {name} if one is specified, or all installable servers.';
    };
  };

  M.util.create_module_commands("_root", M._root.commands)
end

local mt = {}
function mt:__index(k)
  return skeleton[k]
end

return setmetatable(M, mt)
-- vim:et ts=2 sw=2
