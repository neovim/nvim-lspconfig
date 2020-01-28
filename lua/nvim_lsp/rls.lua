local skeleton = require 'nvim_lsp/skeleton'
local util = require 'nvim_lsp/util'
local lsp = vim.lsp

skeleton.rls = {
  default_config = {
    cmd = {"rls"};
    filetypes = {"rust"};
    root_dir = util.root_pattern("Cargo.toml");
    log_level = lsp.protocol.MessageType.Warning;
    settings = {};
  };
  docs = {
    vscode = "rust-lang.rust";
    package_json = "https://github.com/rust-lang/rls-vscode/raw/master/package.json";
    description = [[
https://github.com/rust-lang/rls

rls, a language server for Rust

See https://github.com/rust-lang/rls#setup to setup rls itself.
See https://github.com/rust-lang/rls#configuration for rls-specific settings.

If you want to use rls for a particular build, eg nightly, set cmd as follows:

```lua
cmd = {"rustup", "run", "nightly", "rls"}
```
    ]];
    default_config = {
      root_dir = [[root_pattern("Cargo.toml")]];
    };
  };
};
-- vim:et ts=2 sw=2
