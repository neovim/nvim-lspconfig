local configs = require 'nvim_lsp/configs'
local util = require 'nvim_lsp/util'

local name = "groovyls"

local function make_installer()
  local P = util.path.join
  local install_dir = P{util.base_install_dir, name}

  local bin = P{install_dir, "groovy-language-server", "build", "libs", "groovy-language-server.jar"}
  local cmd = {"java", "-jar", bin}

  local X = {}
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
    filetypes = {"groovy"};
    root_dir = util.root_pattern("build.gradle", "pom.xml", "grails-app", ".git");
    log_level = vim.lsp.protocol.MessageType.Warning;
  };
  on_new_config = function(config)
    installer.configure(config)
  end;
  docs = {
    description = [[
https://github.com/sumneko/groovylstmp-language-server

Lua language server. **By default, this doesn't have a `cmd` set.** This is
because it doesn't provide a global binary. We provide an installer for Linux
and macOS using `:LspInstall`.  If you wish to install it yourself, [here is a
guide](https://github.com/sumneko/groovylstmp-language-server/wiki/Build-and-Run-(Standalone)).
So you should set `cmd` yourself like this.

```groovylstmp
require'nvim_lsp'.sumneko_groovylstmp.setup{
  cmd = {"path", "to", "cmd"};
  ...
}
```

If you install via our installer, if you execute `:LspInstallInfo sumneko_groovylstmp`, you can know `cmd` value.
]];
    default_config = {
      filetypes = { "groovy" };
      root_dir = [[root_pattern("build.gradle", "pom.xml", "grails-app", ".git")]];
    };
  };
}

configs[name].install = installer.install
configs[name].install_info = installer.info
-- vim:et ts=2 sw=2
