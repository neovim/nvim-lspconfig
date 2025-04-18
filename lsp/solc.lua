---@brief
---
-- https://docs.soliditylang.org/en/latest/installing-solidity.html
--
-- solc is the native language server for the Solidity language.
return {
  cmd = { 'solc', '--lsp' },
  filetypes = { 'solidity' },
  root_markers = function(name, _)
    local patterns = { 'hardhat.config.*', '.git' }
    for _, pattern in ipairs(patterns) do
      if vim.glob.to_lpeg(pattern):match(name) ~= nil then
        return true
      end
    end
    return false
  end,
}
