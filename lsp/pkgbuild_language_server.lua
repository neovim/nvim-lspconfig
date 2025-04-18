---@brief
---
--- https://github.com/Freed-Wu/pkgbuild-language-server
---
--- Language server for ArchLinux/Windows Msys2's PKGBUILD.
return {
  cmd = { 'pkgbuild-language-server' },
  filetypes = { 'PKGBUILD' },
  root_markers = { '.git' },
}
