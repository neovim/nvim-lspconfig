---@brief
---
--- https://github.com/bad-antics/lateralus-lang
---
--- Lateralus Language Server, providing IDE features for the Lateralus programming language.
---
--- The language server can be installed via:
--- ```sh
--- curl -fsSL https://lateralus.dev/install.sh | sh
--- ```
---
--- Or via cargo:
--- ```sh
--- cargo install lateralus-lsp
--- ```
---
--- Configuration:
--- ```lua
--- vim.lsp.config('lateralus_ls', {
---   settings = {
---     lateralus = {
---       inlayHints = {
---         enable = true,
---         typeHints = true,
---         parameterHints = true,
---       },
---       diagnostics = {
---         enable = true,
---       },
---       completion = {
---         autoImport = true,
---       }
---     }
---   }
--- })
--- ```

return {
  cmd = { 'lateralus-lsp' },
  filetypes = { 'lateralus' },
  root_markers = { 'lateralus.toml', '.git' },
  settings = {
    lateralus = {
      inlayHints = {
        enable = true,
        typeHints = true,
        parameterHints = true,
      },
      diagnostics = {
        enable = true,
      },
      completion = {
        autoImport = true,
      }
    }
  },
  docs = {
    description = [[
https://github.com/bad-antics/lateralus-lang

Lateralus Language Server provides full IDE support for the Lateralus programming language,
including semantic highlighting, code completion, go-to-definition, hover documentation,
rename refactoring, and inlay hints.

Features:
- Semantic syntax highlighting
- Code completion with auto-import
- Go to definition/references
- Hover documentation
- Rename refactoring
- Inlay type hints
- Code actions and quick fixes
- Workspace symbol search

Installation:
```sh
curl -fsSL https://lateralus.dev/install.sh | sh
```
]],
  },
}
