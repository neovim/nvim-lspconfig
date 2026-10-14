---@brief
---
--- https://github.com/Hessesian/kmp-lsp
---
--- Language server for Kotlin Multiplatform projects: Kotlin, Java, and Swift. It is built on tree-sitter and needs no
--- JVM or Gradle import.
---
--- `kmp-lsp` can be installed with Cargo:
--- ```sh
--- cargo install kmp-lsp
--- ```
---
--- Or downloaded from the [GitHub releases page](https://github.com/Hessesian/kmp-lsp/releases). The release archive also
--- has the `kmp-jar-indexer` sidecar, which gives types and docs for library JARs.

---@type vim.lsp.Config
return {
  cmd = { 'kmp-lsp' },
  filetypes = { 'kotlin', 'java', 'swift' },
  -- kmp-lsp moves its root up to the nearest .git, so .git comes first: one client per repository.
  root_markers = {
    '.git',
    'settings.gradle',
    'settings.gradle.kts',
    'pom.xml',
    'build.gradle',
    'build.gradle.kts',
    'Package.swift',
  },
}
