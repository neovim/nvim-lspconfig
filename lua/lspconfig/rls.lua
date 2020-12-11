local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.rls = {
  default_config = {
    cmd = {"rls"};
    filetypes = {"rust"};
    root_dir = util.root_pattern("Cargo.toml");
  };
  docs = {
    package_json = "https://raw.githubusercontent.com/rust-lang/rls-vscode/master/package.json";
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
