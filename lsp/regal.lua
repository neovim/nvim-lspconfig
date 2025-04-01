local util = require 'lspconfig.util'

---@brief
---
---https://github.com/StyraInc/regal
--
-- A linter for Rego, with support for running as an LSP server.
--
-- `regal` can be installed by running:
-- ```sh
-- go install github.com/StyraInc/regal@latest
-- ```
return {
  cmd = { 'regal', 'language-server' },
  filetypes = { 'rego' },
  root_dir = function(bufnr, done_callback)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    done_callback(
      util.root_pattern '*.rego'(fname) or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    )
  end,
}
