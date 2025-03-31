local util = require 'lspconfig.util'

---@brief
---
---https://github.com/nim-lang/langserver
--
--
-- `nim-langserver` can be installed via the `nimble` package manager:
-- ```sh
-- nimble install nimlangserver
-- ```
return {
  cmd = { 'nimlangserver' },
  filetypes = { 'nim' },
  root_dir = function(bufnr, done_callback)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    done_callback(
      util.root_pattern '*.nimble'(fname) or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    )
  end,
}
