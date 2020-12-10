local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'
local server_name = 'als'
local bin_name = 'ada_language_server'

if vim.fn.has('win32') == 1 then
  bin_name = 'ada_language_server.exe'
end

local function make_installer()
  local install_dir = util.path.join{util.base_install_dir, server_name}

  local url = 'https://dl.bintray.com/reznikmm/ada-language-server/linux-latest.tar.gz'
  local download_target = util.path.join{install_dir, "als.tar.gz"}
  local extracted_dir = "linux"
  local extract_cmd = string.format("tar -xzf '%s' --one-top-level='%s'", download_target, install_dir)

  if vim.fn.has('win32') == 1 then
    url = 'https://dl.bintray.com/reznikmm/ada-language-server/win32-latest.zip'
    download_target = util.path.join{install_dir, 'win32-latest.zip'}
    extracted_dir = 'win32'
    extract_cmd = string.format("unzip -o '%s' -d '%s'", download_target, install_dir)
  elseif vim.fn.has('mac') == 1 then
    url = 'https://dl.bintray.com/reznikmm/ada-language-server/darwin-latest.tar.gz'
    download_target = util.path.join{install_dir, 'darwin-latest.tar.gz'}
    extracted_dir = 'darwin'
    extract_cmd = string.format("tar -xzf '%s' --one-top-level='%s'", download_target, install_dir)
  end

  local download_cmd = string.format('curl -fLo "%s" --create-dirs "%s"', download_target, url)

  local bin_path = util.path.join{install_dir, extracted_dir, bin_name}
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
  end
  function X.info()
    return {
      is_installed = util.path.exists(bin_path);
      install_dir = install_dir;
      cmd = { bin_path };
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
    cmd = {bin_name};
    filetypes = {"ada"};
    -- *.gpr and *.adc would be nice to have here
    root_dir = util.root_pattern("Makefile", ".git");
  };
  on_new_config = function(config)
    installer.configure(config)
  end;
  docs = {
    package_json = "https://raw.githubusercontent.com/AdaCore/ada_language_server/master/integration/vscode/ada/package.json";
    description = [[
https://github.com/AdaCore/ada_language_server

Ada language server. Use `LspInstall als` to install it.

Can be configured by passing a "settings" object to `als.setup{}`:

```lua
require('lspconfig').als.setup{
    settings = {
      ada = {
        projectFile = "project.gpr";
        scenarioVariables = { ... };
      }
    }
}
```
]];
    default_config = {
      root_dir = [[util.root_pattern("Makefile", ".git")]];
    };
  };
};

configs[server_name].install = installer.install
configs[server_name].install_info = installer.info
-- vim:et ts=2 sw=2
