local server_configs = require 'nvim_lsp/server_configs'
local lsp = vim.lsp

server_configs.pyls = {
  default_config = {
    cmd = {"pyls"};
    filetypes = {"python"};
    root_dir = vim.loop.os_homedir;
    log_level = lsp.protocol.MessageType.Warning;
    settings = {};
  };
  -- on_new_config = function(new_config) end;
  -- on_attach = function(client, bufnr) end;
  docs = {
    package_json = "https://github.com/palantir/python-language-server/raw/develop/vscode-client/package.json";
    description = [[
https://github.com/palantir/python-language-server

`python-language-server`, a language server for Python.
    ]];
    default_config = {
      root_dir = "vim's starting directory";
    };
  };
};

-- vim:et ts=2 sw=2
