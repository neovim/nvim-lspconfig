local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local name = "pyls_ms"

local function get_latest_pyls()
  local f = io.popen("curl -k --silent 'https://pvsc.blob.core.windows.net/python-language-server-stable?restype=container&comp=list&prefix=Python-Language-Server-osx-x64'")
  local l = f:read("*a")
  f:close()
  local version
  for w in  string.gmatch (l, "x64%.(.-).nupkg") do
      version = w
  end
  return version
end

local function make_installer()
  local P = util.path.join
  local install_dir = P{util.base_install_dir, name}

  local bin = P{install_dir, "Microsoft.Python.LanguageServer.dll"}
  local cmd = {"dotnet", "exec", bin}

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
    if not (util.has_bins("dotnet")) then
      error('Need ".NET Core" to install this.')
      return
    end

    local system
    if vim.fn.has('mac') == 1 then
      system = 'osx'
    elseif vim.fn.has('unix') == 1 then
      system = 'linux'
    elseif vim.fn.has('win32') == 1 then
      system = 'win'
    else
      error('Unable to identify host operating system')
    end

    local version = get_latest_pyls()
    local url = string.format("https://pvsc.azureedge.net/python-language-server-stable/Python-Language-Server-%s-x64.%s.nupkg", string.lower(system), version)
    local download_cmd = string.format('curl -fLo %s --create-dirs %s', install_info.install_dir .. "/pyls.nupkg", url)
    local install_cmd = ''

    if vim.fn.has('mac') == 1 or vim.fn.has('unix') == 1 then
      install_cmd = "unzip " .. install_info.install_dir .. "/pyls.nupkg -d " .. install_info.install_dir
    elseif vim.fn.has('win32') == 1 then
      install_cmd = "Expand-Archive -Force " .. install_info.install_dir .. "/pyls.nupkg -d " .. install_info.install_dir
    end

    vim.fn.system(download_cmd)
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
    filetypes = {"python"};
    root_dir = function(fname)
      return util.find_git_ancestor(fname) or vim.loop.os_homedir()
    end;
    settings = {
      python = {
        analysis = {
          errors = {};
          info = {};
          disabled = {};
        };
      };
    };
    on_new_config = function(config)
      installer.configure(config)
    end;
    init_options = {
      interpreter = {
        properties =
        {
          InterpreterPath = "";
          Version = "";
        };
      };
      displayOptions = {};
      analysisUpdates = true;
      asyncStartup = true;
    };
  };
  docs = {
    description = [[
https://github.com/Microsoft/python-language-server

`python-language-server`, a language server for Python.

Requires [.NET Core](https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-install-script) to run. On Linux or macOS:

```bash
curl -L https://dot.net/v1/dotnet-install.sh | sh
```

`python-language-server` can be installed via `:LspInstall pyls_ms` or you can [build](https://github.com/microsoft/python-language-server/blob/master/CONTRIBUTING.md#setup) your own.

If you want to use your own build, set cmd to point to `Microsoft.Python.languageServer.dll`.

```lua
cmd = { "dotnet", "exec", "path/to/Microsoft.Python.languageServer.dll" };
```

If the `python` interpreter is not in your PATH environment variable, set the `InterpreterPath` and `Version` properties accordingly.

```lua
InterpreterPath = "path/to/python",
Version = "3.8"
```

This server accepts configuration via the `settings` key.

    ]];
    default_config = {
      root_dir = "vim's starting directory";
    };
  };
};

configs[name].install = installer.install
configs[name].install_info = installer.info
-- vim:et ts=2 sw=2
