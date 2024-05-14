local util = require 'lspconfig.util'

local root_files = {
  '.pbls.toml',
}

return {
  default_config = {
    cmd = { 'pbls' },
    filetypes = { 'proto' },
    root_dir = util.root_pattern(unpack(root_files)) or util.find_git_ancestor(),
  },
  docs = {
    description = [[
https://git.sr.ht/~rrc/pbls

Prerequisites: Ensure protoc is on your $PATH.

`pbls` can be installed via `cargo install`:
```sh
cargo install --git https://git.sr.ht/~rrc/pbls
```

pbls is a Language Server for protobuf
]],
    default_config = {
      root_dir = [[root_pattern(".pbls.toml", ".git")]],
    },
  },
}
