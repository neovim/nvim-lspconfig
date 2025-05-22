local util = require 'lspconfig.util'

local bin_name = 'kotlin-lsp'

--- The presence of one of these files indicates a project root directory
--
--  These are configuration files for the various build systems supported by
--  Kotlin.
local root_files = {
  'settings.gradle', -- Gradle (multi-project)
  'settings.gradle.kts', -- Gradle (multi-project)
  'pom.xml', -- Maven
  'build.gradle', -- Gradle
  'build.gradle.kts', -- Gradle
}

return {
  default_config = {
    cmd = { bin_name, "--stdio" }, -- kotlin-lsp
    filetypes = { 'kotlin' },
    root_dir = util.root_pattern(unpack(root_files)),
    single_file_support = true,
  },
  docs = {
    description = [[
    Pre-alpha official Kotlin support for Visual Studio Code and an implementation of Language Server Protocol for the Kotlin language.

    The server is based on IntelliJ IDEA and the IntelliJ IDEA Kotlin Plugin implementation.
    ]],
  },
}
