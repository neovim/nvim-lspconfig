-- pass 0 as the first argument to use STDIN/STDOUT for communication
local cmd = { 'smithy-language-server', '0' }

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'smithy' },
    single_file_support = true,
    root_dir = function(fname)
      return vim.fs.dirname(
        vim.fs.find(
          { 'smithy-build.json', 'build.gradle', 'build.gradle.kts', '.git' },
          { path = fname, upward = true }
        )[1]
      )
    end,
  },
  docs = {
    description = [[
https://github.com/awslabs/smithy-language-server

`Smithy Language Server`, A Language Server Protocol implementation for the Smithy IDL
]],
  },
}
