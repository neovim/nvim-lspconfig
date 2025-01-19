return {
  default_config = {
    cmd = { 'wgsl_analyzer' },
    filetypes = { 'wgsl' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ '.git' }, { path = fname, upward = true })[1])
    end,
    settings = {},
  },
  docs = {
    description = [[
https://github.com/wgsl-analyzer/wgsl-analyzer

`wgsl_analyzer` can be installed via `cargo`:
```sh
cargo install --git https://github.com/wgsl-analyzer/wgsl-analyzer wgsl_analyzer
```
]],
  },
}
