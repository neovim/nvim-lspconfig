local skeleton = require 'nvim_lsp/skeleton'
local util = require 'nvim_lsp/util'
local lsp = vim.lsp

skeleton.rust_analyzer = {
  default_config = util.utf8_config {
    cmd = {"ra_lsp_server"};
    filetypes = {"rust"};
    root_dir = util.root_pattern("Cargo.toml");
    log_level = lsp.protocol.MessageType.Warning;
    settings = {};
  };
  docs = {
    package_json = "https://github.com/rust-analyzer/rust-analyzer/raw/master/editors/code/package.json";
    description = [[
https://github.com/rust-analyzer/rust-analyzer

rust-analyzer(aka rls 2.0), a language server for Rust

See below for rls specific settings.
https://github.com/rust-analyzer/rust-analyzer/tree/master/docs/user#settings
    ]];
    default_config = {
      root_dir = [[root_pattern("Cargo.toml")]];
    };
  };
};
-- vim:et ts=2 sw=2
