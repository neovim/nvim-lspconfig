---@brief
---
--- https://github.com/idelice/jls
---
--- A Java language server built on the Java compiler API, optimized for Neovim.
--- Supports diagnostics, completion, go-to-definition, hover, find references,
--- document highlights, inlay hints, code actions, rename, and Lombok.
---
--- Install via mason.nvim (recommended):
---   :MasonInstall jls
---
--- Or using the nvim-jls plugin which provides a managed installer:
---   https://github.com/idelice/nvim-jls

---@type vim.lsp.Config
return {
  cmd = { 'jls' },
  filetypes = { 'java' },
  root_markers = {
    'pom.xml',
    'build.gradle',
    'build.gradle.kts',
    'settings.gradle',
    'settings.gradle.kts',
    'WORKSPACE',
    'WORKSPACE.bazel',
    '.java-version',
  },
  settings = {},
}
