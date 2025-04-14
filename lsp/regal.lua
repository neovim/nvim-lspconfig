---@brief
---
--- https://github.com/StyraInc/regal
---
--- A linter for Rego, with support for running as an LSP server.
---
--- `regal` can be installed by running:
--- ```sh
--- go install github.com/StyraInc/regal@latest
--- ```

return {
  cmd = { 'regal', 'language-server' },
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
