---@brief
---
--- https://github.com/DanielGavin/ols
---
--- `Odin Language Server`.

return {
  cmd = { 'ols' },
  filetypes = { 'odin' },
  root_dir = function(bufnr, on_dir)
    on_dir(vim.fs.root(bufnr, function(name, _)
      local patterns = { 'ols.json', '.git', '*.odin' }
      for _, pattern in ipairs(patterns) do
        if vim.glob.to_lpeg(pattern):match(name) ~= nil then
          return true
        end
      end
      return false
    end))
  end,
}
