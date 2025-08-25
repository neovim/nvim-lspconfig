---@brief
---
--- https://github.com/microsoft/typescript-go
---
--- `typescript-go` is experimental port of the TypeScript compiler (tsc) and language server (tsserver) to the Go programming language.
---
--- `tsgo` can be installed via npm `npm install @typescript/native-preview`.
---
--- ### Monorepo support
---
--- `tsgo` supports monorepos by default. It will automatically find the `tsconfig.json` or `jsconfig.json` corresponding to the package you are working on.
--- This works without the need of spawning multiple instances of `tsgo`, saving memory.
---
--- It is recommended to use the same version of TypeScript in all packages, and therefore have it available in your workspace root. The location of the TypeScript binary will be determined automatically, but only once.
---

local util = require('lspconfig.util')

---@type vim.lsp.Config
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
  root_dir = function(bufnr, on_dir)
    local root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' }
    local project_root = util.monorepo_get_root_dir(bufnr, root_markers)
    -- If `project_root` is nil, we still want to call `on_dir()` because this server supports `standalone`.
    on_dir(project_root)
  end,
}
