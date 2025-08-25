---@brief
---
--- https://github.com/termux/termux-language-server
---
--- Language server for various bash scripts such as Arch PKGBUILD, Gentoo ebuild, Termux build.sh, etc.

---@type vim.lsp.Config
return {
  cmd = { 'termux-language-server' },
  filetypes = { 'PKGBUILD' },
  root_markers = { '.git' },
}
