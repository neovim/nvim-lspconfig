---@brief
---
--- https://github.com/nim-lang/langserver
---
---
--- `nim-langserver` can be installed via the `nimble` package manager:
--- ```sh
--- nimble install nimlangserver
--- ```

local util = require 'lspconfig.util'

return {
  cmd = { 'nimlangserver' },
  filetypes = { 'nim' },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    on_dir(
      util.root_pattern '*.nimble'(fname) or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    )
  end,
}
