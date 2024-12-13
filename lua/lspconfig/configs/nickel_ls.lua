return {
  default_config = {
    cmd = { 'nls' },
    filetypes = { 'ncl', 'nickel' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
  },

  docs = {
    description = [[
Nickel Language Server

https://github.com/tweag/nickel

`nls` can be installed with nix, or cargo, from the Nickel repository.
```sh
git clone https://github.com/tweag/nickel.git
```

Nix:
```sh
cd nickel
nix-env -f . -i
```

cargo:
```sh
cd nickel/lsp/nls
cargo install --path .
```

In order to have lspconfig detect Nickel filetypes (a prerequisite for autostarting a server),
install the [Nickel vim plugin](https://github.com/nickel-lang/vim-nickel).
        ]],
  },
}
