local util = require 'lspconfig.util'

local workspace_markers = { 'build.gradle', 'pom.xml', '.git' }

return {
  default_config = {
    filetypes = { 'java' },
    root_dir = util.root_pattern(unpack(workspace_markers)),
    settings = {},
  },
  docs = {
    description = [[
https://github.com/georgewfraser/java-language-server

Java language server

Point `cmd` to `lang_server_linux.sh` or the equivalent script for macOS/Windows provided by java-language-server
]],
  },
}
