local skeleton = require 'nvim_lsp/skeleton'
local util = require 'nvim_lsp/util'
local lsp = vim.lsp

local name = "pyls_ms"

local function get_active_interpreter()
  local f = io.popen("which python 2>&1")
  local l = f:read("*a")
  f:close()
  return l:match("^%s*(.-)%s*$") 
end

local function get_python_version()
  local f = io.popen("python --version 2>&1") -- runs command
  local l = f:read("*a") -- read output of command
  f:close()
  return l:match("^Python%s*(...).*%s*$")
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
    if not util.has_bins("sh", "chmod", "unzip") then
      error('Need the binaries "sh", "chmod", "unzip" to install this')
      return
    end
    local script = [=[
set -e
# Install dotnet if not available.
which dotnet  >/dev/null || {
  test -x dotnet || {
    curl -L https://dot.net/v1/dotnet-install.sh | sh
  }
  export PATH=$PWD:$PATH
}

# clone project
if [ "$(uname)" == "Darwin" ]
  then 
    curl -fLO https://pvsc.azureedge.net/python-language-server-stable/Python-Language-Server-osx-x64.0.4.114.nupkg
    unzip Python-Language-Server-osx-x64.0.4.114.nupkg
elif [ "$(uname)" == "Linux" ]
  then
    curl -fLO https://pvsc.azureedge.net/python-language-server-stable/Python-Language-Server-linux-x64.0.4.114.nupkg
    unzip Python-Language-Server-linux-x64.0.4.114.nupkg
fi

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

skeleton[name] = {

  default_config = {
    filetypes = {"python"};
    root_dir = function(fname)
      return util.find_git_ancestor(fname) or vim.loop.os_homedir()
    end;
    log_level = lsp.protocol.MessageType.Warning;
    settings = {
      python = {
        analysis = {
          errors = {};
          info = {};
          disabled = {},
        };
      };
    };
    on_new_config = function(config)
      installer.configure(config)
    end;
    init_options = {
      interpreter = 
                {
                    properties= 
                    {
                        InterpreterPath=get_active_interpreter();
                        Version=get_python_version(),
                    };
                },
      displayOptions= {
                preferredFormat= 'markdown',
                trimDocumentationLines= false,
                maxDocumentationLineLength= 0,
                trimDocumentationText= false,
                maxDocumentationTextLength= 0,
                };
      analysisUpdates=true,
      asyncStartup=true,
    };
  };
  -- on_new_config = function(new_config) end;
  -- on_attach = function(client, bufnr) end;
  docs = {
    description = [[
    https://github.com/Microsoft/python-language-server
    `python-language-server`, a language server for Python.
    ]];
    default_config = {
      root_dir = "vim's starting directory";
    };
  };
};

skeleton[name].install = installer.install
skeleton[name].install_info = installer.info
