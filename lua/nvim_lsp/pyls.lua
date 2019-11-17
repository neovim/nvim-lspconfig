local skeleton = require 'nvim_lsp/skeleton'
local util = require 'nvim_lsp/util'
local lsp = vim.lsp

skeleton.pyls = {
  default_config = {
    cmd = {"pyls"};
    filetypes = {"python"};
    root_dir = util.once(vim.loop.cwd());
    log_level = lsp.protocol.MessageType.Warning;
    settings = {};
  };
  -- on_new_config = function(new_config) end;
  -- on_attach = function(client, bufnr) end;
  docs = {
    description = [[
https://github.com/palantir/python-language-server

python-language-server, a language server for Python

the following settings (with default options) are supported:
```lua
settings = {
  pyls = {
    enable = true;
    trace = { server = "verbose"; };
    commandPath = "";
    configurationSources = { "pycodestyle" };
    plugins = {
      jedi_completion = { enabled = true; };
      jedi_hover = { enabled = true; };
      jedi_references = { enabled = true; };
      jedi_signature_help = { enabled = true; };
      jedi_symbols = {
        enabled = true;
        all_scopes = true;
      };
      mccabe = {
        enabled = true;
        threshold = 15;
      };
      preload = { enabled = true; };
      pycodestyle = { enabled = true; };
      pydocstyle = {
        enabled = false;
        match = "(?!test_).*\\.py";
        matchDir = "[^\\.].*";
      };
      pyflakes = { enabled = true; };
      rope_completion = { enabled = true; };
      yapf = { enabled = true; };
    };
  };
};
```
    ]];
    default_config = {
      root_dir = "vim's starting directory";
    };
  };
};

-- vim:et ts=2 sw=2
