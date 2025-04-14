---@brief
---
--- https://github.com/haskell/haskell-language-server
---
--- Haskell Language Server
---
--- If you are using HLS 1.9.0.0, enable the language server to launch on Cabal files as well:
---
--- ```lua
--- vim.lsp.config('hls', {
---   filetypes = { 'haskell', 'lhaskell', 'cabal' },
--- })
--- ```

return {
  cmd = { 'haskell-language-server-wrapper', '--lsp' },
  filetypes = { 'haskell', 'lhaskell' },
  root_dir = function(bufnr, on_dir)
    on_dir(vim.fs.root(bufnr, function(name, _)
      local patterns = { 'hie.yaml', 'stack.yaml', 'cabal.project', '*.cabal', 'package.yaml' }
      for _, pattern in ipairs(patterns) do
        if vim.glob.to_lpeg(pattern):match(name) ~= nil then
          return true
        end
      end
      return false
    end))
  end,
  settings = {
    haskell = {
      formattingProvider = 'ormolu',
      cabalFormattingProvider = 'cabalfmt',
    },
  },
}
