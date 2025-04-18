---@brief
---
--- https://github.com/georgewfraser/java-language-server
---
--- Java language server
---
--- Point `cmd` to `lang_server_linux.sh` or the equivalent script for macOS/Windows provided by java-language-server
return {
  filetypes = { 'java' },
  root_markers = { 'build.gradle', 'build.gradle.kts', 'pom.xml', '.git' },
  settings = {},
}
