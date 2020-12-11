local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'
local server_name = 'omnisharp'
local bin_name = 'run'

local function make_installer()
  local install_dir = util.path.join{util.base_install_dir, server_name}
  local pid = vim.fn.getpid()
  local url = 'linux-x64'

  if vim.fn.has('win32') == 1 then
    url = 'win-x64'
    bin_name = 'Omnisharp.exe'
  elseif vim.fn.has('mac') == 1 then
    url = 'osx'
  end
  local bin_path = util.path.join{install_dir, bin_name}

  local download_target = util.path.join{install_dir, string.format("omnisharp-%s.zip", url)}
  local extract_cmd = string.format("unzip '%s' -d '%s'", download_target, install_dir)
  local download_cmd = string.format('curl -fLo "%s" --create-dirs "https://github.com/OmniSharp/omnisharp-roslyn/releases/latest/download/omnisharp-%s.zip"', download_target, url)
  local make_executable_cmd = string.format("chmod u+x '%s'", bin_path)

  local X = {}
  function X.install()
    local install_info = X.info()
    if install_info.is_installed then
      print(server_name, "is already installed")
      return
    end
    if not (util.has_bins("curl")) then
      error('Need "curl" to install this.')
      return
    end
    vim.fn.mkdir(install_dir, 'p')
    vim.fn.system(download_cmd)
    vim.fn.system(extract_cmd)
    vim.fn.system(make_executable_cmd)
  end
  function X.info()
    return {
      is_installed = util.path.exists(bin_path);
      install_dir = install_dir;
      cmd = { bin_path, "--languageserver" , "--hostPID", tostring(pid)};
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

configs[server_name] = {
  default_config = {
    cmd = installer.info().cmd;
    filetypes = {"cs", "vb"};
    root_dir = util.root_pattern("*.csproj", "*.sln");
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
https://github.com/omnisharp/omnisharp-roslyn
OmniSharp server based on Roslyn workspaces
]];
    default_config = {
      root_dir = [[root_pattern(".csproj", ".sln")]];
    };
  };
}

configs[server_name].install = installer.install
configs[server_name].install_info = installer.info
-- vim:et ts=2 sw=2
