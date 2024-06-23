local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'protols' },
    filetypes = { 'proto' },
    single_file_support = true,
    root_dir = util.find_git_ancestor,
  },
  docs = {
    description = [[
https://github.com/coder3101/protols

`protols` can be installed via `cargo`:
```sh
cargo install protols
```

A Language Server for proto3 files. It uses tree-sitter and runs in single file mode.
]],
  },
}
