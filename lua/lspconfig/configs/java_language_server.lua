-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- This config is DEPRECATED.
-- Use the configs in `lsp/` instead (requires Nvim 0.11).
--
-- ALL configs in `lua/lspconfig/configs/` will be DELETED.
-- They exist only to support Nvim 0.10 or older.
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
local util = require 'lspconfig.util'

return {
  default_config = {
    filetypes = { 'java' },
    root_dir = util.root_pattern('build.gradle', 'build.gradle.kts', 'pom.xml', '.git'),
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
