---@brief
---
--- https://github.com/microsoft/typescript-go
---
--- `typescript-go` is experimental port of the TypeScript compiler (tsc) and language server (tsserver) to the Go programming language.
---
--- `tsgo` can be installed via npm `npm install @typescript/native-preview`.
return {
  cmd = { 'tsgo', '--lsp', '--stdio' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
}
