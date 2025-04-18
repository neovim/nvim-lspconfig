---@brief
---
--- https://github.com/grahambates/m68k-lsp
---
--- Language server for Motorola 68000 family assembly
---
--- `m68k-lsp-server` can be installed via `npm`:
---
--- ```sh
--- npm install -g m68k-lsp-server
--- ```
---
--- Ensure you are using the 68k asm syntax variant in Neovim.
---
--- ```lua
--- vim.g.asmsyntax = 'asm68k'
--- ```
return {
  cmd = { 'm68k-lsp-server', '--stdio' },
  filetypes = { 'asm68k' },
  root_markers = { 'Makefile', '.git' },
}
