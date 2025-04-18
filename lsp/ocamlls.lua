---@brief
---
--- https://github.com/ocaml-lsp/ocaml-language-server
---
--- `ocaml-language-server` can be installed via `npm`
--- ```sh
--- npm install -g ocaml-language-server
--- ```

local util = require 'lspconfig.util'

return {
  cmd = { 'ocaml-language-server', '--stdio' },
  filetypes = { 'ocaml', 'reason' },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    on_dir(util.root_pattern('*.opam', 'esy.json', 'package.json')(fname))
  end,
}
