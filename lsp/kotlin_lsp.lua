---@brief
---Pre-alpha official Kotlin support for Visual Studio Code and an implementation of Language Server Protocol for the Kotlin language.
---
---The server is based on IntelliJ IDEA and the IntelliJ IDEA Kotlin Plugin implementation.

--- The presence of one of these files indicates a project root directory
--
--  These are configuration files for the various build systems supported by
--  Kotlin.
return {
  filetypes = { 'kotlin' },
  cmd = { 'kotlin-lsp', '--stdio' },
  root_markers = {
    'settings.gradle', -- Gradle (multi-project)
    'settings.gradle.kts', -- Gradle (multi-project)
    'pom.xml', -- Maven
    'build.gradle', -- Gradle
    'build.gradle.kts', -- Gradle
    'workspace.json', -- Used to integrate your own build system
  },
}
