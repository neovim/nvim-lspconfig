---@brief
---
--- https://github.com/digital-asset/ghcide
---
--- A library for building Haskell IDE tooling.
--- "ghcide" isn't for end users now. Use "haskell-language-server" instead of "ghcide".

---@type vim.lsp.Config
return {
  cmd = { 'ghcide', '--lsp' },
  filetypes = { 'haskell', 'lhaskell' },
  root_markers = { 'stack.yaml', 'hie-bios', 'BUILD.bazel', 'cabal.config', 'package.yaml' },
}
