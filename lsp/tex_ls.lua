---@brief
---
--- https://github.com/backmatter/tex-ls
---
--- Language server for LaTeX and BibTeX with completion, navigation, diagnostics,
--- and formatting. Install `tex-ls` using the instructions at:
--- https://github.com/backmatter/tex-ls#install
---
--- Project configuration is read from `tex-ls.toml`.

---@type vim.lsp.Config
return {
  cmd = { 'tex-ls', 'lsp' },
  filetypes = { 'tex', 'plaintex', 'bib' },
  root_markers = { 'tex-ls.toml', '.git' },
}
