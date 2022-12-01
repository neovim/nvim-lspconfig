local util = require 'lspconfig.util'

local workspace_markers = { '*.sln', '*.csproj', '*.fsproj', '.git' }

return {
  default_config = {
    cmd = { 'csharp-ls' },
    root_dir = util.root_pattern(unpack(workspace_markers)),
    filetypes = { 'cs' },
    init_options = {
      AutomaticWorkspaceInit = true,
    },
  },
  docs = {
    description = [[
https://github.com/razzmatazz/csharp-language-server

Language Server for C#.

csharp-ls requires the [dotnet-sdk](https://dotnet.microsoft.com/download) to be installed.

The preferred way to install csharp-ls is with `dotnet tool install --global csharp-ls`.
    ]],
  },
}
