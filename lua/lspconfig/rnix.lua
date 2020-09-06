local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local name = "rnix"

local function make_installer()
  local P = util.path.join
  local install_dir = P{util.base_install_dir, name}

  local bin = P{install_dir, "bin", "rnix-lsp"}
  local cmd = {bin}

  local X = {}
  function X.install()
    local install_info = X.info()
    if install_info.is_installed then
      print(name, "is already installed")
      return
    end
    if not (util.has_bins("cargo")) then
      error('Need "cargo" to install this.')
      return
    end

    local install_cmd = "cargo install rnix-lsp --root=" .. install_info.install_dir .. " rnix-lsp"

    vim.fn.system(install_cmd)
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
    cmd = {"rnix-lsp"};
    filetypes = {"nix"};
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
  docs = {
    description = [[
https://github.com/nix-community/rnix-lsp

A language server for Nix providing basic completion and formatting via nixpkgs-fmt.

To install manually, run `cargo install rnix-lsp`. If you are using nix, rnix-lsp is in nixpkgs.

This server accepts configuration via the `settings` key.

    ]];
    default_config = {
      root_dir = "vim's starting directory";
    };
  };
};

configs[name].install = installer.install
configs[name].install_info = installer.info
