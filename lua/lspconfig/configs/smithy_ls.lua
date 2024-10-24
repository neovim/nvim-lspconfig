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
