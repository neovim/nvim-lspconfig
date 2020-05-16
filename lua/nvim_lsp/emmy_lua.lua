local configs = require 'nvim_lsp/configs'
local util = require 'nvim_lsp/util'

local name = "emmy_lua"

local function make_installer()
  local P = util.path.join
  local install_dir = P{util.base_install_dir, name}

  local bin = P{install_dir, "EmmyLua-LS-all.jar"}
  local cmd = {"java -cp " .. bin .. " com.tang.vscode.MainKt"}

  local X = {}
  function X.install()
    local install_info = X.info()
    if install_info.is_installed then
      print(name, "is already installed")
      return
    end
    if not (util.has_bins("curl")) then
      error('Need "curl" to install this.')
      return
    end
    if not (util.has_bins("java")) then
      error('Need "java" to run this.')
      return
    end

    local url = "https://github.com/EmmyLua/EmmyLua-LanguageServer/releases/download/0.3.6/EmmyLua-LS-all.jar"
    local download_cmd = string.format('curl -fLo %s --create-dirs %s', install_info.install_dir .. "/EmmyLua-LS-all.jar", url)

    vim.fn.system(download_cmd)
  end
  function X.info()
    return {
      is_installed = util.path.exists(bin);
      install_dir = install_dir;
      cmd = cmd;
    }
  end
  function X.configure(config)
    local install_info = X.info()
    if install_info.is_installed then
      config.cmd = cmd
    end
  end
  return X
end

local installer = make_installer()

configs[name] = {

  default_config = {
    filetypes = {"lua"};
    root_dir = function(fname)
      return util.find_git_ancestor(fname) or vim.loop.os_homedir()
    end;
    settings = {
    };
    on_new_config = function(config)
      installer.configure(config)
    end;
    init_options = {
    };
  };
  -- on_new_config = function(new_config) end;
  -- on_attach = function(client, bufnr) end;
  docs = {
    description = [[
https://github.com/EmmyLua/EmmyLua-LanguageServer

A language server for lua. 

This server accepts configuration via the `settings` key.

    ]];
    default_config = {
      root_dir = "vim's starting directory";
    };
  };
};

configs[name].install = installer.install
configs[name].install_info = installer.info
