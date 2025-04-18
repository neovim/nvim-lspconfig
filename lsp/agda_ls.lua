---@brief
---
-- https://github.com/agda/agda-language-server
--
-- Language Server for Agda.
return {
  cmd = { 'als' },
  filetypes = { 'agda' },
  root_markers = function(name, _)
    local patterns = { '.git', '*.agda-lib' }
    for _, pattern in ipairs(patterns) do
      if vim.glob.to_lpeg(pattern):match(name) ~= nil then
        return true
      end
    end
    return false
  end,
}
