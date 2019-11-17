local skeleton = require 'nvim_lsp/skeleton'
local util = require 'nvim_lsp/util'
local lsp = vim.lsp

local server_name = "jdtls"

skeleton[server_name] = {
  default_config = {
    cmd = {"jdtls"};
    filetypes = {"java"};
    root_dir = vim.loop.os_homedir;
    log_level = lsp.protocol.MessageType.Warning;
    settings = {};
  };
  -- on_attach = function(client, bufnr) end;
  docs = {
    description = [[
For language server related questions visit:
https://github.com/eclipse/eclipse.jdt.ls
]];
    default_config = {
      root_dir = "vim's starting directory";
    };
  };
};

-- vim:et ts=2 sw=2
