---@brief
---
--- https://www.npmjs.com/package/@snakeskin/cli
---
--- `snakeskin cli` can be installed via `npm`:
--- ```sh
--- npm install -g @snakeskin/cli
--- ```
return {
  cmd = { 'snakeskin-cli', 'lsp', '--stdio' },
  filetypes = { 'ss' },
  root_markers = { 'package.json' },
}
