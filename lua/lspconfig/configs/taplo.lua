return {
  default_config = {
    cmd = { 'taplo', 'lsp', 'stdio' },
    filetypes = { 'toml' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://taplo.tamasfe.dev/cli/usage/language-server.html

Language server for Taplo, a TOML toolkit.

`taplo-cli` can be installed via `cargo`:
```sh
cargo install --features lsp --locked taplo-cli
```
    ]],
  },
}
