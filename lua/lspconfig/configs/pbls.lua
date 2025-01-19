return {
  default_config = {
    cmd = { 'pbls' },
    filetypes = { 'proto' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ '.pbls.toml', '.git' }, { path = fname, upward = true })[1])
    end,
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
  },
}
