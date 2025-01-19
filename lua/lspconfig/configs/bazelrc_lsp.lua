return {
  default_config = {
    cmd = { 'bazelrc-lsp' },
    filetypes = { 'bazelrc' },
    root_dir = function(fname)
      return vim.fs.dirname(
        vim.fs.find({ 'WORKSPACE', 'WORKSPACE.bazel', 'MODULE.bazel' }, { path = fname, upward = true })[1]
      )
    end,
  },
  docs = {
    description = [[
https://github.com/salesforce-misc/bazelrc-lsp

`bazelrc-lsp` is a LSP for `.bazelrc` configuration files.

The `.bazelrc` file type is not detected automatically, you can register it manually (see below) or override the filetypes:

```lua
vim.filetype.add {
  pattern = {
    ['.*.bazelrc'] = 'bazelrc',
  },
}
```
]],
  },
}
