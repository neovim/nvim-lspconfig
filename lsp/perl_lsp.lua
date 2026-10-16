---@brief
---
--- https://github.com/tree-sitter-perl/perl-lsp
---
--- A Perl language server built on tree-sitter-perl, with cross-file type inference. It can be
--- installed via `cargo`:
--- ```sh
--- cargo install perl-lsp
--- ```

---@type vim.lsp.Config
return {
  cmd = { 'perl-lsp' },
  filetypes = { 'perl' },
  root_markers = { 'cpanfile', 'Makefile.PL', 'Build.PL', '.git' },
}
