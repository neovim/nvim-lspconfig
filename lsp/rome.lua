---@brief
---
--- https://rome.tools
---
--- Language server for the Rome Frontend Toolchain.
---
--- (Unmaintained, use [Biome](https://biomejs.dev/blog/annoucing-biome) instead.)
---
--- ```sh
--- npm install [-g] rome
--- ```
return {
  cmd = { 'rome', 'lsp-proxy' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'json',
    'typescript',
    'typescript.tsx',
    'typescriptreact',
  },
  root_markers = { 'package.json', 'node_modules', '.git' },
}
