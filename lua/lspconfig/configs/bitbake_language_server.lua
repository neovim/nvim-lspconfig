return {
  default_config = {
    cmd = { 'bitbake-language-server' },
    filetypes = { 'bitbake' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/Freed-Wu/bitbake-language-server

`bash-language-server` can be installed via `pip`:
```sh
pip install bitbake-language-server
```

Language server for bitbake.
]],
  },
}
