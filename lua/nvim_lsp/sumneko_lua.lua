local skeleton = require 'nvim_lsp/skeleton'
local util = require 'nvim_lsp/util'
local vim = vim

local name = "sumneko_lua"

local function make_installer()
  local P = util.path.join
  local install_dir = P{util.base_install_dir, name}
  local git_dir = P{install_dir, "lua-language-server"}

  local bin = P{git_dir, "bin", "Linux", "lua-language-server"}
  local main_file = P{git_dir, "main.lua"}
  local cmd = {bin, '-E', main_file}

  local X = {}
  function X.install()
    local install_info = X.info()
    if install_info.is_installed then
      print(name, "is already installed")
      return
    end
    if not (util.has_bins("ninja") or util.has_bins("curl")) then
      error('Need either "ninja" or "curl" (to download ninja) to install this.')
      return
    end
    if not util.has_bins("sh", "chmod", "unzip") then
      error('Need the binaries "sh", "chmod", "unzip" to install this')
      return
    end
    local script = [=[
set -e
# Install ninja if not available.
which ninja >/dev/null || {
  test -x ninja || {
    curl -LO https://github.com/ninja-build/ninja/releases/download/v1.9.0/ninja-linux.zip
    unzip ninja-linux.zip
    chmod +x ninja
  }
  export PATH=$PWD:$PATH
}

# clone project
git clone https://github.com/sumneko/lua-language-server
cd lua-language-server
git submodule update --init --recursive

# build
cd 3rd/luamake
ninja -f ninja/linux.ninja
cd ../..
./3rd/luamake/luamake rebuild
    ]=]
    vim.fn.mkdir(install_info.install_dir, "p")
    util.sh(script, install_info.install_dir)
  end
  function X.info()
    return {
      is_installed = util.has_bins(bin);
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

skeleton[name] = {
  default_config = {
    filetypes = {'lua'};
    root_dir = function(fname)
      return util.find_git_ancestor(fname) or vim.loop.os_homedir()
    end;
    log_level = vim.lsp.protocol.MessageType.Warning;
    settings = {};
  };
  on_new_config = function(config)
    installer.configure(config)
  end;
  docs = {
    vscode = "sumneko.lua";
    description = [[
https://github.com/sumneko/lua-language-server

Lua language server. **By default, this doesn't have a `cmd` set.** This is
because it doesn't provide a global binary. We provide an installer for Linux
using `:LspInstall`.  If you wish to install it yourself, [here is a
guide](https://github.com/sumneko/lua-language-server/wiki/Build-and-Run).
]];
    default_config = {
      root_dir = [[root_pattern(".git") or os_homedir]];
    };
  };
}

skeleton[name].install = installer.install
skeleton[name].install_info = installer.info
-- vim:et ts=2
