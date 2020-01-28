local skeleton = require 'nvim_lsp/skeleton'
local util = require 'nvim_lsp/util'
local lsp = vim.lsp

skeleton.gopls = {
  default_config = {
    cmd = {"gopls"};
    filetypes = {"go"};
    root_dir = util.root_pattern("go.mod", ".git");
    log_level = lsp.protocol.MessageType.Warning;
    settings = {};
  };
  -- on_new_config = function(new_config) end;
  -- on_attach = function(client, bufnr) end;
  docs = {
    description = [[
https://github.com/golang/tools/tree/master/gopls

Google's lsp server for golang.
]];
    default_config = {
      root_dir = [[root_pattern("go.mod", ".git")]];
    };
  };
}
-- vim:et ts=2 sw=2
