local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

-- neovim doesn't support the full 3.16 spec, but latest rust-analyzer requires the following capabilities.
-- Remove once implemented.
local default_capabilities = vim.lsp.protocol.make_client_capabilities()
default_capabilities.workspace.workspaceEdit = {
  normalizesLineEndings = true;
  changeAnnotationSupport = {
    groupsOnLabel = true;
  };
};
default_capabilities.textDocument.rename.prepareSupportDefaultBehavior = 1;

configs.rust_analyzer = {
  default_config = {
    cmd = {"rust-analyzer"};
    filetypes = {"rust"};
    root_dir = util.root_pattern("Cargo.toml", "rust-project.json");
    settings = {
      ["rust-analyzer"] = {}
    };
    capabilities = default_capabilities;
  };
  docs = {
    package_json = "https://raw.githubusercontent.com/rust-analyzer/rust-analyzer/master/editors/code/package.json";
    description = [[
https://github.com/rust-analyzer/rust-analyzer

rust-analyzer (aka rls 2.0), a language server for Rust

See [docs](https://github.com/rust-analyzer/rust-analyzer/tree/master/docs/user#settings) for extra settings.
    ]];
    default_config = {
      root_dir = [[root_pattern("Cargo.toml", "rust-project.json")]];
    };
  };
};
-- vim:et ts=2 sw=2
