local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local name = "sumneko_lua"
local bin_name = "lua-language-server"

local function make_installer()
  local P = util.path.join
  local install_dir = P{util.base_install_dir, name}
  local git_dir = P{install_dir, bin_name}
  local os, bin, ninja_zip, build_file

  if vim.fn.has('osx') == 1 then
    os = 'macOS'
    bin = P{git_dir, "bin", "macOS", bin_name}
    ninja_zip = "ninja-mac.zip"
    build_file = "macos.ninja"
  elseif vim.fn.has('unix') == 1 then
    os = 'Linux'
    bin = P{git_dir, "bin", "Linux", bin_name}
    ninja_zip = "ninja-linux.zip"
    build_file = "linux.ninja"
  end
  local main_file = P{git_dir, "main.lua"}
  local cmd = {bin, '-E', main_file}

  local X = {}
  function X.install()
    if os == nil then
      error("This installer supports Linux and macOS only")
      return
    end
    local install_info = X.info()
    if install_info.is_installed then
      print(name, "is already installed")
      return
    end
    if not (util.has_bins("ninja") or util.has_bins("curl")) then
      error('Need either "ninja" or "curl" (to download ninja) to install this.')
      return
    end
    if not util.has_bins("sh", "chmod", "unzip", "clang") then
      error('Need the binaries "sh", "chmod", "unzip", "clang" to install this')
      return
    end
    local script = [=[
set -e
bin_name=]=]..bin_name..'\n'..[=[
ninja_zip=]=]..ninja_zip..'\n'..[=[
build_file=]=]..build_file..'\n'..[=[

# Install ninja if not available.
which ninja >/dev/null || {
  test -x ninja || {
    curl -LO https://github.com/ninja-build/ninja/releases/download/v1.9.0/$ninja_zip
    unzip $ninja_zip
    chmod +x ninja
  }
  export PATH="$PWD:$PATH"
}

# clone project
git clone https://github.com/sumneko/$bin_name
cd $bin_name
git submodule update --init --recursive

# build
cd 3rd/luamake
ninja -f ninja/$build_file
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

configs[name] = {
  default_config = {
    filetypes = {'lua'};
    root_dir = function(fname)
      return util.find_git_ancestor(fname) or util.path.dirname(fname)
    end;
    log_level = vim.lsp.protocol.MessageType.Warning;
  };
  on_new_config = function(config)
    installer.configure(config)
  end;
  docs = {
    package_json = "https://raw.githubusercontent.com/sumneko/vscode-lua/master/package.json";
    description = [[
https://github.com/sumneko/lua-language-server

Lua language server. **By default, this doesn't have a `cmd` set.** This is
because it doesn't provide a global binary. We provide an installer for Linux
and macOS using `:LspInstall`.  If you wish to install it yourself, [here is a
guide](https://github.com/sumneko/lua-language-server/wiki/Build-and-Run-(Standalone)).
So you should set `cmd` yourself like this.

```lua
require'lspconfig'.sumneko_lua.setup{
  cmd = {"path", "to", "cmd"};
  ...
}
```

If you install via our installer, if you execute `:LspInstallInfo sumneko_lua`, you can know `cmd` value.
]];
    default_config = {
      root_dir = [[root_pattern(".git") or bufdir]];
    };
  };
}

configs[name].install = installer.install
configs[name].install_info = installer.info
-- vim:et ts=2
