return {
  default_config = {
    cmd = { 'openscad-lsp', '--stdio' },
    filetypes = { 'openscad' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [=[
https://github.com/Leathong/openscad-LSP

A Language Server Protocol server for OpenSCAD

You can build and install `openscad-lsp` binary with `cargo`:
```sh
cargo install openscad-lsp
```
]=],
  },
}
