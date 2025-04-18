---@brief
---
--- https://github.com/awslabs/smithy-language-server
---
--- `Smithy Language Server`, A Language Server Protocol implementation for the Smithy IDL

-- pass 0 as the first argument to use STDIN/STDOUT for communication
local cmd = { 'smithy-language-server', '0' }

return {
  cmd = cmd,
  filetypes = { 'smithy' },
  root_markers = { 'smithy-build.json', 'build.gradle', 'build.gradle.kts', '.git' },
}
