local configs = require 'nvim_lsp/configs'
local util = require 'nvim_lsp/util'

configs.pyls = {
  default_config = {
    cmd = {"pyls"};
    filetypes = {"python"};
    root_dir = function(fname)
      return util.path.dirname(fname)
    end;
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
