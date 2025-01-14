return {
  default_config = {
    cmd = { 'alloy', 'lsp' },
    filetypes = { 'alloy' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/AlloyTools/org.alloytools.alloy

Alloy is a formal specification language for describing structures and a tool for exploring them.

You may also need to configure the filetype for Alloy (*.als) files:

```
autocmd BufNewFile,BufRead *.als set filetype=alloy
```

or

```lua
vim.filetype.add({
  pattern = {
    ['.*/*.als'] = 'alloy',
  },
})
```

Alternatively, you may use a syntax plugin like https://github.com/runoshun/vim-alloy.
]],
  },
}
