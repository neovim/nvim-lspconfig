local util = require 'lspconfig.util'

---@brief
---
---https://docs.soliditylang.org/en/latest/installing-solidity.html
--
-- solc is the native language server for the Solidity language.
return {
  cmd = { 'solc', '--lsp' },
  filetypes = { 'solidity' },
  root_dir = function(bufnr, done_callback)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    done_callback(util.root_pattern('hardhat.config.*', '.git')(fname))
  end,
}
