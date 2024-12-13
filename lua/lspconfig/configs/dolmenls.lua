return {
  default_config = {
    cmd = { 'dolmenls' },
    filetypes = { 'smt2', 'tptp', 'p', 'cnf', 'icnf', 'zf' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/Gbury/dolmen/blob/master/doc/lsp.md

`dolmenls` can be installed via `opam`
```sh
opam install dolmen_lsp
```
    ]],
  },
}
