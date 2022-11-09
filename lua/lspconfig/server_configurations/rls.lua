local util = require 'lspconfig.util'

local workspace_markers = { 'Cargo.toml' }

return {
  default_config = {
    cmd = { 'rls' },
    filetypes = { 'rust' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  docs = {
    description = [[
https://github.com/rust-lang/rls

rls, a language server for Rust

See https://github.com/rust-lang/rls#setup to setup rls itself.
See https://github.com/rust-lang/rls#configuration for rls-specific settings.
All settings listed on the rls configuration section of the readme
must be set under settings.rust as follows:

```lua
nvim_lsp.rls.setup {
  settings = {
    rust = {
      unstable_features = true,
      build_on_save = false,
      all_features = true,
    },
  },
}
```

If you want to use rls for a particular build, eg nightly, set cmd as follows:

```lua
cmd = {"rustup", "run", "nightly", "rls"}
```
    ]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
