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

return {
  cmd = { 'regols' },
  filetypes = { 'rego' },
  root_dir = function(bufnr, on_dir)
    on_dir(vim.fs.root(bufnr, function(name, _)
      local patterns = { '*.rego', '.git' }
      for _, pattern in ipairs(patterns) do
        if vim.glob.to_lpeg(pattern):match(name) ~= nil then
          return true
        end
      end
      return false
    end))
  end,
}
