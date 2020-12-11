local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local name = "groovyls"
local bin_name = "groovy-language-server-all.jar"

local function make_installer()
  local X = {}
  local P = util.path.join
  local install_dir = P{util.base_install_dir, name}
  local bin_path = P{install_dir, "groovy-language-server", "build", "libs", bin_name}
  local cmd = {
    "java", "-jar", bin_path,
  };

  function X.install()
    local install_info = X.info()
    if install_info.is_installed then
      print(name, "is already installed.")
      return
    end
    if not (util.has_bins("curl")) then
      error('Need "curl" to install this.')
      return
    end
    if not (util.has_bins("java")) then
      error('Need "Java 11+" to install this.')
      return
    end

    local script = [=[
set -e
# clone project
git clone https://github.com/prominic/groovy-language-server.git
cd groovy-language-server

# build
./gradlew build
    ]=]
    vim.fn.mkdir(install_info.install_dir, "p")
    util.sh(script, install_info.install_dir)
  end

  function X.info()
    return {
      is_installed = util.path.exists(bin_path);
      install_dir = install_dir;
      cmd = cmd
    }
  end

  function X.configure(config)
      local install_info = X.info()
      if install_info.is_installed then
          config.cmd = install_info.cmd
      end
  end
  return X
end

local installer = make_installer()

configs[name] = {
  default_config = {
    cmd = {
      "java", "-jar", bin_name
    },
    filetypes = {"groovy"};
    root_dir = util.root_pattern(".git") or vim.loop.os_homedir();
  };
  on_new_config = function(config)
    installer.configure(config)
  end;
  docs = {
    description = [[
https://github.com/prominic/groovy-language-server.git

Requirements:
 - Linux/macOS (for now)
 - Java 11+

`groovyls` can be installed via `:LspInstall groovyls` or by yourself by following the instructions [here](https://github.com/prominic/groovy-language-server.git#build).

The command `:LspInstall groovyls` makes an attempt at installing the binary by
Fetching the groovyls repository from GitHub, compiling it and then expose a binary.

If you installed groovy language server by yourself, you can set the `cmd` custom path as follow:

```lua
require'lspconfig'.groovyls.setup{
    -- Unix
    cmd = { "java", "-jar", "path/to/groovyls/groovy-language-server-all.jar" },
    ...
}
```
]];
    default_config = {
      cmd = {
        "java", "-jar", bin_name
      },
      filetypes = {"groovy"};
      root_dir = [[root_pattern(".git") or vim.loop.os_homedir()]];
    };
  };
}

configs[name].install = installer.install
configs[name].install_info = installer.info
-- vim:et ts=2 sw=2
