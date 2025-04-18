---@brief
---
--- https://github.com/Gbury/dolmen/blob/master/doc/lsp.md
---
--- `dolmenls` can be installed via `opam`
--- ```sh
--- opam install dolmen_lsp
--- ```
return {
  cmd = { 'dolmenls' },
  filetypes = { 'smt2', 'tptp', 'p', 'cnf', 'icnf', 'zf' },
  root_markers = { '.git' },
}
