-- Author: Heyward Fann <fannheyward@gmail.com>
-- Description: rust-analyzer for nvim-lsp

local skeleton = require 'nvim_lsp/skeleton'
local util = require 'nvim_lsp/util'
local vim = vim
local lsp = vim.lsp

skeleton.rust_analyzer = {
  default_config = {
    cmd = {"ra_lsp_server"};
    filetypes = {"rust"};
    root_dir = util.root_pattern("Cargo.toml", ".git");
    log_level = lsp.protocol.MessageType.Warning;
    settings = {};
  };
  commands = {
  };
  -- on_new_config = function(new_config) end;
  -- on_attach = function(client, bufnr) end;
  docs = {
    description = [[
https://rust-analyzer.github.io

Bringing great IDE experience to the Rust programming language.

the following settings (with default options) are supported:
```lua
settings = {
  ["rust-analyzer"] = {
    trace = { server = "verbose"; };
    excludeGlobs = {};
    featureFlags = {
      ["lsp.diagnostics"] = true;
      ["completion.insertion.add-call-parenthesis"] = true;
      ["completion.enable-postfix"] = true;
      ["notifications.workspace-loaded"] = false;
    }
  }
};
```
]];
    default_config = {
      root_dir = [[root_pattern("Cargo.toml", ".git")]];
    };
  };
}

-- vim:et ts=2 sw=2
