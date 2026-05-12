---@brief
---
--- https://github.com/netmute/ctags-lsp
---
--- A simple LSP server wrapping universal-ctags. Provides completion,
--- go-to-definition, and document/workspace symbols. Useful as a generic
--- symbol provider for languages without a dedicated language server, or
--- as a fallback alongside other LSPs.
---
--- Requires `universal-ctags` to be installed and available in `$PATH`.
--- Pre-built binaries are at https://github.com/netmute/ctags-lsp/releases
--- (Homebrew: `brew install netmute/tap/ctags-lsp`).
---
--- The server is generic and does not declare default `filetypes`. Configure
--- the languages you want it to attach to:
---
--- ```lua
--- vim.lsp.config('ctags_lsp', {
---   filetypes = { 'lua', 'ruby', 'go' },
--- })
--- vim.lsp.enable('ctags_lsp')
--- ```

---@type vim.lsp.Config
return {
  cmd = { 'ctags-lsp' },
  root_markers = { 'tags', '.tags', '.git' },
}
