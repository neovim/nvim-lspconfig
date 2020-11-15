local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'
local lsp = vim.lsp
local api = vim.api

local server_name = "elmls"
local bin_name = "elm-language-server"

local installer = util.npm_installer {
  server_name = server_name;
  packages = { "elm", "elm-test", "elm-format", "@elm-tooling/elm-language-server" };
  binaries = {bin_name, "elm", "elm-format", "elm-test"};
}

local default_capabilities = lsp.protocol.make_client_capabilities()
default_capabilities.offsetEncoding = {"utf-8", "utf-16"}
local elm_root_pattern = util.root_pattern("elm.json")

configs[server_name] = {
  default_config = {
    cmd = {bin_name};
    -- TODO(ashkan) if we comment this out, it will allow elmls to operate on elm.json. It seems like it could do that, but no other editor allows it right now.
    filetypes = {"elm"};
    root_dir = function(fname)
      local filetype = api.nvim_buf_get_option(0, 'filetype')
      if filetype == 'elm' or (filetype == 'json' and fname:match("elm%.json$")) then
        return elm_root_pattern(fname)
      end
    end;
    init_options = {
      elmPath = "elm",
      elmFormatPath = "elm-format",
      elmTestPath = "elm-test",
      elmAnalyseTrigger = "change",
    };
  };
  on_new_config = function(new_config)
    local install_info = installer.info()
    if install_info.is_installed then
      if type(new_config.cmd) == 'table' then
        -- Try to preserve any additional args from upstream changes.
        new_config.cmd[1] = install_info.binaries[bin_name]
      else
        new_config.cmd = {install_info.binaries[bin_name]}
      end
      new_config.init_options = util.tbl_deep_extend('force', new_config.init_options, {
        elmPath = install_info.binaries["elm"];
        elmFormatPath = install_info.binaries["elm-format"];
        elmTestPath = install_info.binaries["elm-test"];
      })
    end
  end;
  docs = {
    package_json = "https://raw.githubusercontent.com/elm-tooling/elm-language-client-vscode/master/package.json";
    description = [[
https://github.com/elm-tooling/elm-language-server#installation

If you don't want to use Nvim to install it, then you can use:
```sh
npm install -g elm elm-test elm-format @elm-tooling/elm-language-server
```
]];
    default_config = {
      root_dir = [[root_pattern("elm.json")]];
    };
  };
}

configs[server_name].install = installer.install
configs[server_name].install_info = installer.info
-- vim:et ts=2 sw=2

