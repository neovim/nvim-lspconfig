local language_id_of = {
  menhir = 'ocaml.menhir',
  ocaml = 'ocaml',
  ocamlinterface = 'ocaml.interface',
  ocamllex = 'ocaml.ocamllex',
  reason = 'reason',
  dune = 'dune',
}

local get_language_id = function(_, ftype)
  return language_id_of[ftype]
end

return {
  default_config = {
    cmd = { 'ocamllsp' },
    filetypes = { 'ocaml', 'menhir', 'ocamlinterface', 'ocamllex', 'reason', 'dune' },
    root_dir = function(fname)
      return vim.fs.dirname(
        vim.fs.find(
          { '*.opam', 'esy.json', 'package.json', '.git', 'dune-project', 'dune-workspace' },
          { path = fname, upward = true }
        )[1]
      )
    end,
    get_language_id = get_language_id,
  },
  docs = {
    description = [[
https://github.com/ocaml/ocaml-lsp

`ocaml-lsp` can be installed as described in [installation guide](https://github.com/ocaml/ocaml-lsp#installation).

To install the lsp server in a particular opam switch:
```sh
opam install ocaml-lsp-server
```
    ]],
  },
}
