---@brief
---
--- https://github.com/kitagry/regols
---
--- OPA Rego language server.
---
--- `regols` can be installed by running:
--- ```sh
--- go install github.com/kitagry/regols@latest
--- ```

local util = require 'lspconfig.util'

return {
  cmd = { 'regols' },
  filetypes = { 'rego' },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    on_dir(util.root_pattern '*.rego'(fname) or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1]))
  end,
}
