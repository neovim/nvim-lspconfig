local configs = require 'nvim_lsp/configs'
local util = require 'nvim_lsp/util'
local path = util.path

local server_name = "apex_jorje"
local jar_name = "apex-jorje-lsp.jar"
local lsp_url = "https://github.com/forcedotcom/salesforcedx-vscode/blob/develop/packages/salesforcedx-vscode-apex/out/" .. jar_name
local install_dir = path.join {util.base_install_dir, server_name}
local cmd = {
      "java",
      "-cp",
      path.join(install_dir, jar_name),
      "-Ddebug.internal.errors=true",
      "-Ddebug.semantic.errors=true",
      "apex.jorje.lsp.ApexLanguageServerLauncher"
    };


local function make_installer()
  local script = "curl -LO " .. lsp_url;

  local X = {}

  function X.install()
    if not util.has_bins("curl") then
      error("need curl binary to install")
      return
    end

    vim.fn.mkdir(install_dir, "p")
    util.sh(script, install_dir)
  end

  function X.info()
    return {
      is_installed = util.path.exists(install_dir) ~= false;
      install_dir = install_dir;
      cmd = cmd;
    }
  end

  return X
end

local installer = make_installer()

configs[server_name] = {
  default_config = {
    cmd = cmd;
    filetypes = {"apex"};
    root_dir = util.root_pattern("sfdx-project.json", ".git");
  };
  docs = {
    description = [[
https://developer.salesforce.com/tools/vscode/en/apex/language-server/

Language server for Apex
    ]];
  };
};

configs[server_name].install = installer.install
configs[server_name].install_info = installer.info
