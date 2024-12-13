return {
  default_config = {
    cmd = { 'lelwel-ls' },
    filetypes = { 'llw' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/0x2a-42/lelwel

Language server for lelwel grammars.

You can install `lelwel-ls` via cargo:
```sh
cargo install --features="lsp" lelwel
```
]],
  },
}
