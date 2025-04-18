---@brief
---
--- https://github.com/suoto/hdl_checker
--- Language server for hdl-checker.
--- Install using: `pip install hdl-checker --upgrade`
return {
  cmd = { 'hdl_checker', '--lsp' },
  filetypes = { 'vhdl', 'verilog', 'systemverilog' },
  root_markers = { '.git' },
}
