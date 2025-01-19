return {
  default_config = {
    cmd = { 'ocaml-language-server', '--stdio' },
    filetypes = { 'ocaml', 'reason' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ '*.opam', 'esy.json', 'package.json' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/ocaml-lsp/ocaml-language-server

`ocaml-language-server` can be installed via `npm`
```sh
npm install -g ocaml-language-server
```
    ]],
  },
}
