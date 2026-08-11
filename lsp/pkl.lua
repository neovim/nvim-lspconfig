--- @brief
---
--- https://github.com/apple/pkl-lsp
---
--- Language server for [Pkl](https://pkl-lang.org/), a configuration language by Apple.
---
--- `pkl-lsp` can be installed via Homebrew:
--- ```sh
--- brew install pkl
--- ```
---
--- Or downloaded from the [GitHub releases page](https://github.com/apple/pkl/releases).

---@type vim.lsp.Config
return {
  cmd = { 'pkl-lsp' },
  filetypes = { 'pkl', 'pcf' },
  root_markers = { 'PklProject', '.git' },
}
