return {
  default_config = {
    cmd = { 'flux-lsp' },
    filetypes = { 'flux' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/influxdata/flux-lsp
`flux-lsp` can be installed via `cargo`:
```sh
cargo install --git https://github.com/influxdata/flux-lsp
```
]],
  },
}
