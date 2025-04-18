---@brief
---
--- https://github.com/ghdl/ghdl-language-server
---
--- A language server for VHDL, using ghdl as its backend.
---
--- `ghdl-ls` is part of pyghdl, for installation instructions see
--- [the upstream README](https://github.com/ghdl/ghdl/tree/master/pyGHDL/lsp).
return {
  cmd = { 'ghdl-ls' },
  filetypes = { 'vhdl' },
  root_markers = { 'hdl-prj.json', '.git' },
}
