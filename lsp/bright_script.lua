---@brief
---
--- https://github.com/RokuCommunity/brighterscript
---
--- `brightscript` can be installed via `npm`:
--- ```sh
--- npm install -g brighterscript
--- ```
return {
  cmd = { 'bsc', '--lsp', '--stdio' },
  filetypes = { 'brs' },
  root_markers = { 'makefile', 'Makefile', '.git' },
}
