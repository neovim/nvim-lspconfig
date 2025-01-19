return {
  default_config = {
    cmd = { 'bufls', 'serve' },
    filetypes = { 'proto' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'buf.work.yaml', '.git' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/bufbuild/buf-language-server

`buf-language-server` can be installed via `go install`:
```sh
go install github.com/bufbuild/buf-language-server/cmd/bufls@latest
```

bufls is a Protobuf language server compatible with Buf modules and workspaces
]],
  },
}
