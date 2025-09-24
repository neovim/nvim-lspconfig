---@brief
---
--- https://github.com/ocaml/ocaml-lsp
---
--- `ocaml-lsp` can be installed as described in [installation guide](https://github.com/ocaml/ocaml-lsp#installation).
---
--- To install the lsp server in a particular opam switch:
--- ```sh
--- opam install ocaml-lsp-server
--- ```

local language_id_of = {
  menhir = 'ocaml.menhir',
  ocaml = 'ocaml',
  ocamlinterface = 'ocaml.interface',
  ocamllex = 'ocaml.ocamllex',
  reason = 'reason',
  dune = 'dune',
}

local language_id_of_ext = {
  mll = language_id_of.ocamllex,
  mly = language_id_of.menhir,
  mli = language_id_of.ocamlinterface,
}

local get_language_id = function(bufnr, ftype)
  if ftype == 'ocaml' then
    local path = vim.api.nvim_buf_get_name(bufnr)
    local ext = vim.fn.fnamemodify(path, ':e')
    return language_id_of_ext[ext] or language_id_of.ocaml
  else
    return language_id_of[ftype]
  end
end

local root_markers1 = { 'dune-project', 'dune-workspace' }
local root_markers2 = { '*.opam', 'opam', 'esy.json', 'package.json' }
local root_markers3 = { '.git' }

---@type vim.lsp.Config
return {
  cmd = { 'ocamllsp' },
  filetypes = { 'ocaml', 'menhir', 'ocamlinterface', 'ocamllex', 'reason', 'dune' },
  root_markers = vim.fn.has('nvim-0.11.3') == 1 and { root_markers1, root_markers2, root_markers3 }
    or vim.list_extend(vim.list_extend(root_markers1, root_markers2), root_markers3),
  get_language_id = get_language_id,
}
