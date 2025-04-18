---@brief
---
-- https://github.com/nim-lang/langserver
--
--
-- `nim-langserver` can be installed via the `nimble` package manager:
-- ```sh
-- nimble install nimlangserver
-- ```
return {
  cmd = { 'nimlangserver' },
  filetypes = { 'nim' },
  root_markers = function(name, _)
    local patterns = { '*.nimble', '.git' }
    for _, pattern in ipairs(patterns) do
      if vim.glob.to_lpeg(pattern):match(name) ~= nil then
        return true
      end
    end
    return false
  end,
}
