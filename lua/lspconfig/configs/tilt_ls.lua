return {
  default_config = {
    cmd = { 'tilt', 'lsp', 'start' },
    filetypes = { 'tiltfile' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/tilt-dev/tilt

Tilt language server.

You might need to add filetype detection manually:

```vim
autocmd BufRead Tiltfile setf=tiltfile
```
]],
  },
}
