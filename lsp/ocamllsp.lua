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

local get_language_id = function(_, ftype)
  return language_id_of[ftype]
end

return {
  cmd = { 'ocamllsp' },
  filetypes = { 'ocaml', 'menhir', 'ocamlinterface', 'ocamllex', 'reason', 'dune' },
  root_dir = function(bufnr, on_dir)
    on_dir(vim.fs.root(bufnr, function(name, _)
      local patterns = { '*.opam', 'esy.json', 'package.json', '.git', 'dune-project', 'dune-workspace' }
      for _, pattern in ipairs(patterns) do
        if vim.glob.to_lpeg(pattern):match(name) ~= nil then
          return true
        end
      end
      return false
    end))
  end,
  get_language_id = get_language_id,
}
