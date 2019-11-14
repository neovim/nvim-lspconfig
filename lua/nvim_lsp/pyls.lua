local skeleton = require 'nvim_lsp/skeleton'
local util = require 'nvim_lsp/util'
local lsp = vim.lsp

local cwd = vim.loop.cwd()

skeleton.pyls = {
  default_config = {
    cmd = {"pyls"};
    filetypes = {"python"};
    root_dir = function() return cwd end;
    log_level = lsp.protocol.MessageType.Warning;
  };
  -- on_new_config = function(new_config) end;
  -- on_attach = function(client, bufnr) end;
  docs = {
    description = [[
https://github.com/palantir/python-language-server

python-language-server, a language server for Python
]];
    default_config = {
      root_dir = "vim's starting directory";
    };
  };
}

-- vim:et ts=2 sw=2
