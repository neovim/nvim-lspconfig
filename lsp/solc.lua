---@brief
---
--- https://docs.soliditylang.org/en/latest/installing-solidity.html
---
--- solc is the native language server for the Solidity language.

local util = require 'lspconfig.util'

return {
  cmd = { 'solc', '--lsp' },
  filetypes = { 'solidity' },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    on_dir(util.root_pattern('hardhat.config.*', '.git')(fname))
  end,
}
