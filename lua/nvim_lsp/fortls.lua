local skeleton = require 'nvim_lsp/skeleton'
local util = require 'nvim_lsp/util'
local lsp = vim.lsp

skeleton.fortls = {
  default_config = {
    cmd = {"fortls"};
    filetypes = {"fortran"};
    root_dir = util.root_pattern(".fortls");
    log_level = lsp.protocol.MessageType.Warning;
    settings = {
      nthreads = 1,
    };
  };
  -- on_new_config = function(new_config) end;
  -- on_attach = function(client, bufnr) end;
  docs = {
    vscode = 'hansec.fortran-ls';
    description = [[
https://github.com/hansec/fortran-language-server

Fortran Language Server for the Language Server Protocol
    ]];
    default_config = {
      root_dir = [[root_pattern(".fortls")]];
    };
  };
};

-- vim:et ts=2 sw=2
