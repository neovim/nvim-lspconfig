---@brief
---
--- https://github.com/hudson-trading/slang-server
---
--- A SystemVerilog language server based on the Slang library.
---
--- Release binaries can be downloaded from [here](https://github.com/hudson-trading/slang-server/releases)
--- and placed in a directory on PATH.
---
--- See [the docs](https://hudson-trading.github.io/slang-server/start/config/) for options.

---@type vim.lsp.Config
return {
  cmd = { 'slang-server' },
  filetypes = { 'systemverilog', 'verilog' },
  root_markers = { '.git', '.slang' },
}
