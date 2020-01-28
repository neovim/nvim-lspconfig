local skeleton = require 'nvim_lsp/skeleton'
local util = require 'nvim_lsp/util'
local lsp = vim.lsp

skeleton.leanls = {
  default_config = {
    cmd = {"lean-language-server", "--stdio"};
    filetypes = {"lean"};
    root_dir = util.root_pattern(".git");
    log_level = lsp.protocol.MessageType.Warning;
    settings = {};
  };
  -- on_new_config = function(new_config) end;
  -- on_attach = function(client, bufnr) end;
  docs = {
    vscode = "jroesch.lean";
    description = [[
https://github.com/leanprover/lean-client-js/tree/master/lean-language-server

Lean language server.
    ]];
    default_config = {
      root_dir = [[util.root_pattern(".git")]];
    };
  };
}
-- vim:et ts=2 sw=2
