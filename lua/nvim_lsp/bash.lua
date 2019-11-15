local skeleton = require 'nvim_lsp/skeleton'
local util = require 'nvim_lsp/util'
local lsp = vim.lsp

local cwd = vim.loop.cwd()

skeleton.bash = {
  default_config = {
    cmd = {"bash-language-server", "start"};
    filetypes = {"sh"};
    root_dir = function() return cwd end;
    log_level = lsp.protocol.MessageType.Warning;
    settings = {};
  };
  -- on_new_config = function(new_config) end;
  -- on_attach = function(client, bufnr) end;
  docs = {
    description = [[
For install instruction visit:
https://github.com/mads-hartmann/bash-language-server#installation
]];
    default_config = {
      root_dir = "vim's starting directory";
    };
  };
};

-- vim:et ts=2 sw=2
