-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- This config is DEPRECATED.
-- Use the configs in `lsp/` instead (requires Nvim 0.11).
--
-- ALL configs in `lua/lspconfig/configs/` will be DELETED.
-- They exist only to support Nvim 0.10 or older.
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
local util = require 'lspconfig.util'

-- pass 0 as the first argument to use STDIN/STDOUT for communication
local cmd = { 'smithy-language-server', '0' }

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'smithy' },
    single_file_support = true,
    root_dir = util.root_pattern('smithy-build.json', 'build.gradle', 'build.gradle.kts', '.git'),
  },
  docs = {
    description = [[
https://github.com/awslabs/smithy-language-server

`Smithy Language Server`, A Language Server Protocol implementation for the Smithy IDL
]],
  },
}
