return {
  default_config = {
    cmd = { 'move-analyzer' },
    filetypes = { 'move' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'Move.toml' }, { path = fname, upward = true })[1])
    end,
  },
  commands = {},
  docs = {
    description = [[
https://github.com/move-language/move/tree/main/language/move-analyzer

Language server for Move

The `move-analyzer` can be installed by running:

```
cargo install --git https://github.com/move-language/move move-analyzer
```

See [`move-analyzer`'s doc](https://github.com/move-language/move/blob/1b258a06e3c7d2bc9174578aac92cca3ac19de71/language/move-analyzer/editors/code/README.md#how-to-install) for details.
    ]],
  },
}
