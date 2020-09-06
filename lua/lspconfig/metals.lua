local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'
local server_name = "metals"
local bin_name = "metals"

local function make_installer()
  local install_dir = util.path.join{util.base_install_dir, server_name}
  local metals_bin = util.path.join{install_dir, bin_name}
  local server_version
  if (vim.g.metals_server_version) then
    server_version = vim.g.metals_server_version
  else
    server_version = 'latest.release'
  end
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
    if not (util.has_bins("java")) then
      error('Need "JDK" to install this.')
      return
    end

    local coursier_exe = nil
    if util.has_bins("cs") then
      coursier_exe = "cs"
    elseif util.has_bins("coursier") then
      coursier_exe = "coursier"
    end
    if not coursier_exe then
      coursier_exe = install_dir .. "/coursier"
      local download_cmd = string.format("curl -fLo %s --create-dirs https://git.io/coursier-cli", coursier_exe)
      local chmod_cmd = string.format("chmod +x %s", coursier_exe)
      vim.fn.system(download_cmd)
      vim.fn.system(chmod_cmd)
    else
      os.execute("mkdir -p " .. install_dir)
    end

    local install_cmd = string.format("%s bootstrap --java-opt -Xss4m --java-opt -Xms100m org.scalameta:metals_2.12:%s -r bintray:scalacenter/releases -r sonatype:snapshots -o %s -f", coursier_exe, server_version, metals_bin)
    vim.fn.system(install_cmd)
  end
  function X.info()
    return {
      is_installed = util.path.exists(metals_bin);
      install_dir = install_dir;
      cmd = { metals_bin };
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
    filetypes = {"scala"};
    root_dir = util.root_pattern("build.sbt", "build.sc", "build.gradle", "pom.xml");
    message_level = vim.lsp.protocol.MessageType.Log;
    init_options = {
        statusBarProvider = "show-message",
        isHttpEnabled = true,
        compilerOptions = {
          snippetAutoIndent = false
        }
      };
  };
  on_new_config = function(config)
    installer.configure(config)
  end;
  docs = {
    package_json = "https://raw.githubusercontent.com/scalameta/metals-vscode/master/package.json";
    description  = [[
https://scalameta.org/metals/

To target a specific version on Metals, set the following.
If nothing is set, the latest stable will be used.
```vim
let g:metals_server_version = '0.8.4+106-5f2b9350-SNAPSHOT'
```

Scala language server with rich IDE features.
`metals` can be installed via `:LspInstall metals`.
]];
    default_config = {
      root_dir = [[util.root_pattern("build.sbt", "build.sc", "build.gradle", "pom.xml")]];
    };
  };
};

configs[server_name].install      = installer.install
configs[server_name].install_info = installer.info
