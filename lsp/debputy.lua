---@brief
---
--- https://salsa.debian.org/debian/debputy
---
--- Language Server for Debian packages.
return {
  cmd = { 'debputy', 'lsp', 'server' },
  filetypes = { 'debcontrol', 'debcopyright', 'debchangelog', 'autopkgtest', 'make', 'yaml' },
  root_markers = { 'debian' },
}
