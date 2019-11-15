local skeleton = require 'nvim_lsp/skeleton'
local util = require 'nvim_lsp/util'
local lsp = vim.lsp
local fn = vim.fn
local api = vim.api
local need_bins = util.need_bins

local default_capabilities = lsp.protocol.make_client_capabilities()
default_capabilities.offsetEncoding = {"utf-8", "utf-16"}

local bin_name = "typescript-language-server"

local install_dir = util.path.join(fn.stdpath("cache"), "nvim_lsp", "typescript-language-server")

local function get_install_info()
  local bin_dir = util.path.join(install_dir, "node_modules", ".bin")
  local bins = { bin_dir = bin_dir; install_dir = install_dir; }
  bins.tsserver = util.path.join(bin_dir, bin_name)
  bins.is_installed = need_bins(bins.tsserver)
  return bins
end

local global_commands = {
  TsServerInstall = {
    function()
      if get_install_info().is_installed then
        return print('typescript-language-server is already installed')
      end
      skeleton.tsserver.install()
    end;
    description = 'Install typescript-language-server and its dependencies to stdpath("cache")/nvim_lsp/typescript-language-server';
  };
  TsServerInstallInfo = {
    function()
      local install_info = get_install_info()
      if not install_info.is_installed then
        return print('typescript-language-server is not installed')
      end
      print(vim.inspect(install_info))
    end;
    description = 'Print installation infor for `typescript-language-server`'
  }
};

util.create_module_commands("typescript-language-server", global_commands)

local tsserver_root_patter = util.root_pattern("package.json")

skeleton.tsserver = {
  default_config = {
    cmd = {bin_name};
    filetypes = {"typescript", "typescriptreact", "typescript.tsx"};
    root_dir = util.root_pattern("package.json");
    log_level = lsp.protocol.MessageType.Warning;
    settings = {};
    capabilities = default_capabilities;
    on_init = function(client, result)
      if result.offsetEncoding then
        client.offset_encoding = result.offsetEncoding
      end
    end
  };
  commands = global_commands;
  on_new_config = function(new_config)
    local install_info = get_install_info()
    if install_info.is_installed then
      new_config.cmd = {install_info.elmls}
    end
    print(vim.inspect(new_config))
  end;
  docs = {
    description = [[
https://github.com/theia-ide/typescript-language-server

typescript-language-server relies on having a few dependencies installed:
```sh
npm install -g typescript-language-server
```
]];
    default_config = {
      root_dir = [[root_pattern("package.json")]];
      on_init = [[function to handle changing offsetEncoding]];
      capabilities = [[default capabilities, with offsetEncoding utf-8]];
    };
  };
}

function skeleton.tsserver.install()
  if not need_bins(bin_name) then return end
  if not need_bins("sh", "npm", "mkdir", "cd") then
    vim.api.nvim_err_writeln('Installation requires "sh", "npm", "mkdir", "cd"')
    return
  end
  local install_info = get_install_info()
  if install_info.is_installed then
    return
  end
  local cmd = io.popen("sh", "w")
  local install_script = ([[
set -eo pipefail
mkdir -p "{{install_dir}}"
cd "{{install_dir}}"
npm install typescript-language-server
]]):gsub("{{(%S+)}}", install_info)
  print(install_script)
  cmd:write(install_script)
  cmd:close()
end

skeleton.tsserver.get_install_info = get_install_info
-- vim:et ts=2 sw=2
