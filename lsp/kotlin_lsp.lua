---@brief
---
--- https://github.com/Kotlin/kotlin-lsp
---
--- Pre-alpha official Kotlin support for Visual Studio Code and an implementation of Language Server Protocol for the Kotlin language.
---
--- `kotlin-lsp` can be installed by following the instructions [here](https://github.com/Kotlin/kotlin-lsp?tab=readme-ov-file#supported-platforms).
---
--- The default `cmd` assumes that the `kotlin-ls` language server [startup script](https://github.com/Kotlin/kotlin-lsp/blob/main/scripts/kotlin-lsp.sh) can be found in `$PATH`.
---
--- See `kotlin-lsp`'s [documentation](https://github.com/Kotlin/kotlin-lsp/blob/main/scripts/neovim.md) for more details.
---
local root_files = {
  'settings.gradle', -- Gradle (multi-project)
  'settings.gradle.kts', -- Gradle (multi-project)
  'build.xml', -- Ant
  'pom.xml', -- Maven
  'build.gradle', -- Gradle
  'build.gradle.kts', -- Gradle
}

return {
  cmd = { 'kotlin-ls', '--stdio' },
  single_file_support = true,
  filetypes = { 'kotlin' },
  root_markers = root_files,
}
