local util = require 'lspconfig.util'

local host_dll_name = 'MSBuildProjectTools.LanguageServer.Host.dll'

return {
  default_config = {
    filetypes = { 'xml.csproj', 'xml.fsproj', 'sln' },
    root_dir = util.find_git_ancestor,
    init_options = {},
    cmd = { 'dotnet', host_dll_name },
  },
  docs = {
    description = [[
https://github.com/tintoy/msbuild-project-tools-server/

MSBuild Project Tools Server can be installed by following the README.MD on the above repository.

Example config:
```lua
lspconfig.msbuild_project_tools_server.setup {
  cmd = {'dotnet', '/path/to/server/MSBuildProjectTools.LanguageServer.Host.dll'}
}
```

]],
    default_config = {
      root_dir = [[root_pattern('.git')]],
    },
  },
}
