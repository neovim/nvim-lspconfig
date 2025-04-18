---@brief
---
--- https://github.com/StyraInc/regal
---
--- A linter for Rego, with support for running as an LSP server.
---
--- `regal` can be installed by running:
--- ```sh
--- go install github.com/StyraInc/regal@latest
--- ```

local util = require 'lspconfig.util'

return {
  cmd = { 'regal', 'language-server' },
  filetypes = { 'rego' },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    on_dir(util.root_pattern '*.rego'(fname) or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1]))
  end,
}
