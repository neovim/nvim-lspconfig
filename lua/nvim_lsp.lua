local skeleton = require 'nvim_lsp/skeleton'

require 'nvim_lsp/bashls'
require 'nvim_lsp/ccls'
require 'nvim_lsp/clangd'
require 'nvim_lsp/cssls'
require 'nvim_lsp/dockerls'
require 'nvim_lsp/elmls'
require 'nvim_lsp/flow'
require 'nvim_lsp/fortls'
require 'nvim_lsp/ghcide'
require 'nvim_lsp/gopls'
require 'nvim_lsp/hie'
require 'nvim_lsp/intelephense'
require 'nvim_lsp/leanls'
require 'nvim_lsp/pyls'
require 'nvim_lsp/pyls_ms'
require 'nvim_lsp/rls'
require 'nvim_lsp/rust_analyzer'
require 'nvim_lsp/solargraph'
require 'nvim_lsp/sumneko_lua'
require 'nvim_lsp/texlab'
require 'nvim_lsp/tsserver'
require 'nvim_lsp/vimls'
require 'nvim_lsp/ocamlls'
require 'nvim_lsp/terraformls'
require 'nvim_lsp/yamlls'

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
      "-complete=custom,v:lua.lsp_complete_installable_servers";
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
      "-complete=custom,v:lua.lsp_complete_servers";
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
