local configs = require 'nvim_lsp/configs'
local util = require 'nvim_lsp/util'
local lsp = vim.lsp

configs.gdscript = {
  default_config = {
    cmd = {"nc", "localhost", "6008"};
    filetypes = {"gd", "gdscript3"};
    root_dir = util.root_pattern("project.godot", ".git");
    log_level = lsp.protocol.MessageType.Warning;
  };
  -- on_new_config = function(new_config) end;
  -- on_attach = function(client, bufnr) end;
  docs = {
    description = [[
https://github.com/godotengine/godot

Language server for GDScript, used by Godot Engine.
]];
    default_config = {
      root_dir = "vim's starting directory";
    };
  };
};

-- vim:et ts=2 sw=2
