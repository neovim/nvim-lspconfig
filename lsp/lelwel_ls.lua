---@brief
---
--- https://github.com/0x2a-42/lelwel
---
--- Language server for lelwel grammars.
---
--- You can install `lelwel-ls` via cargo:
--- ```sh
--- cargo install --features="lsp" lelwel
--- ```
return {
  cmd = { 'lelwel-ls' },
  filetypes = { 'llw' },
  root_markers = { '.git' },
}
