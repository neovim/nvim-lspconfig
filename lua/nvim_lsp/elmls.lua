local skeleton = require 'nvim_lsp/skeleton'
local util = require 'nvim_lsp/util'
local lsp = vim.lsp
local fn = vim.fn
local api = vim.api
local need_bins = util.need_bins

local default_capabilities = lsp.protocol.make_client_capabilities()
default_capabilities.offsetEncoding = {"utf-8", "utf-16"}

local bin_name = "elm-language-server"

local install_dir = util.path.join(fn.stdpath("cache"), "nvim_lsp", "elmls")
local function get_install_info()
  local bin_dir = util.path.join(install_dir, "node_modules", ".bin")
  local bins = { bin_dir = bin_dir; install_dir = install_dir; }
  bins.elmls = util.path.join(bin_dir, bin_name)
  bins.elm = util.path.join(bin_dir, "elm")
  bins.elm_format = util.path.join(bin_dir, "elm-format")
  bins.elm_test = util.path.join(bin_dir, "elm-test")
  bins.is_installed = need_bins(bins.elmls, bins.elm, bins.elm_format, bins.elm_test)
  return bins
end

local global_commands = {
  ElmlsInstall = {
    function()
      if get_install_info().is_installed then
        return print("ElmLS is already installed")
      end
      skeleton.elmls.install()
    end;
    description = 'Install elmls and its dependencies to stdpath("cache")/nvim_lsp/elmls';
  };
  ElmlsInstallInfo = {
    function()
      local install_info = get_install_info()
      if not install_info.is_installed then
        return print("ElmLS is not installed")
      end
      print(vim.inspect(install_info))
    end;
    description = 'Print installation info for `elmls`';
  };
};

util.create_module_commands("elmls", global_commands)

local elm_root_pattern = util.root_pattern("elm.json")

skeleton.elmls = {
  default_config = {
    cmd = {bin_name};
    -- TODO(ashkan) if we comment this out, it will allow elmls to operate on elm.json. It seems like it could do that, but no other editor allows it right now.
    filetypes = {"elm"};
    root_dir = function(fname, bufnr)
      local filetype = api.nvim_buf_get_option(0, 'filetype')
      if filetype == 'elm' or (filetype == 'json' and fname:match("elm%.json$")) then
        return elm_root_pattern(fname)
      end
    end;
    log_level = lsp.protocol.MessageType.Warning;
    settings = {};
    init_options = {
      elmPath = "elm",
      elmFormatPath = "elm-format",
      elmTestPath = "elm-test",
      elmAnalyseTrigger = "change",
    };
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
      util.tbl_deep_extend(new_config.init_options, {
        elmPath = install_info.elm;
        elmFormatPath = install_info.elm_format;
        elmTestPath = install_info.elm_test;
      })
    end
    print(vim.inspect(new_config))
  end;
  docs = {
    description = [[
https://github.com/elm-tooling/elm-language-server#installation

You can install elmls automatically to the path at
  `stdpath("cache")/nvim_lsp/elmls`
by using the function `nvim_lsp.elmls.install()` or the command `:ElmlsInstall`.

This will only install if it can't find `elm-language-server` and if it hasn't
been installed before by neovim.

You can see installation info via `:ElmlsInstallInfo` or via
`nvim_lsp.elmls.get_install_info()`. This will let you know if it is installed.

If you don't want to use neovim to install it, then you can use:
```sh
npm install -g elm elm-test elm-format @elm-tooling/elm-language-server
```
]];
    default_config = {
      root_dir = [[root_pattern("elm.json")]];
      on_init = [[function to handle changing offsetEncoding]];
      capabilities = [[default capabilities, with offsetEncoding utf-8]];
    };
  };
}

function skeleton.elmls.install()
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
npm install elm elm-test elm-format @elm-tooling/elm-language-server
]]):gsub("{{(%S+)}}", install_info)
  print(install_script)
  cmd:write(install_script)
  cmd:close()
end

skeleton.elmls.get_install_info = get_install_info
-- vim:et ts=2 sw=2

