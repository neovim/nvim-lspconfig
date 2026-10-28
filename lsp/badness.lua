---@brief
---
--- https://github.com/jolars/badness
---
--- Badness is a language server, formatter, and linter for LaTeX and BibTeX.
---
--- Install it with `cargo install badness` or see the
--- [installation guide](https://badness.dev/guide/installation.html) for other options.
---
--- See the [editor configuration reference](https://badness.dev/reference/editor-configuration.html)
--- for available settings. Project settings can be configured in `badness.toml`.

---@type vim.lsp.Config
return {
  cmd = { 'badness', 'lsp' },
  filetypes = { 'tex', 'plaintex', 'bib' },
  root_markers = { 'badness.toml', '.git' },
}
