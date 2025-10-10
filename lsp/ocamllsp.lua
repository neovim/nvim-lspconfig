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

-- https://github.com/ocaml/ocaml-lsp/blob/master/ocaml-lsp-server/docs/ocamllsp/switchImplIntf-spec.md
local function switch_impl_intf(bufnr, client)
  local method_name = 'ocamllsp/switchImplIntf'
  ---@diagnostic disable-next-line:param-type-mismatch
  if not client or not client:supports_method(method_name) then
    return vim.notify(('method %s is not supported by any servers active on the current buffer'):format(method_name))
  end
  local uri = vim.lsp.util.make_given_range_params(nil, nil, bufnr, client.offset_encoding).textDocument.uri
  if not uri then
    return vim.notify('could not get URI for current buffer')
  end
  local params = { uri }
  ---@diagnostic disable-next-line:param-type-mismatch
  client:request(method_name, params, function(err, result)
    if err then
      error(tostring(err))
    end
    if not result or #result == 0 then
      vim.notify('corresponding file cannot be determined')
    elseif #result == 1 then
      vim.cmd.edit(vim.uri_to_fname(result[1]))
    else
      vim.ui.select(
        result,
        { prompt = 'Select an implementation/interface:', format_item = vim.uri_to_fname },
        function(choice)
          if choice then
            vim.cmd.edit(vim.uri_to_fname(choice))
          end
        end
      )
    end
  end, bufnr)
end

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
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'LspOcamllspSwitchImplIntf', function()
      switch_impl_intf(bufnr, client)
    end, { desc = 'Switch between implementation/interface' })
  end,
}
