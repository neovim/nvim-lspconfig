local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'taplo', 'lsp', 'stdio' },
    filetypes = { 'toml' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
https://taplo.tamasfe.dev/cli/usage/language-server.html

Language server for Taplo, a TOML toolkit.

`taplo-cli` can be installed via `cargo`:
```sh
cargo install --features lsp --locked taplo-cli
```
    ]],
    default_config = {
      root_dir = [[root_pattern(".git")]],
    },
  },
}
