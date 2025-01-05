local host_dll_name = 'MSBuildProjectTools.LanguageServer.Host.dll'
local util = require 'lspconfig.util'

return {
  default_config = {
    filetypes = { 'msbuild' },
    root_dir = util.root_pattern('*.sln', '*.slnx', '*.*proj', '.git'),
    init_options = {},
    cmd = { 'dotnet', host_dll_name },
  },
  docs = {
    description = [=[
https://github.com/tintoy/msbuild-project-tools-server/

MSBuild Project Tools Server can be installed by following the README.MD on the above repository.

Example config:
```lua
lspconfig.msbuild_project_tools_server.setup {
  cmd = {'dotnet', '/path/to/server/MSBuildProjectTools.LanguageServer.Host.dll'}
}
```

There's no builtin filetypes for msbuild files, would require some filetype aliases:

```lua
vim.filetype.add({
  extension = {
    props = 'msbuild',
    tasks = 'msbuild',
    targets = 'msbuild',
  },
  pattern = {
    [ [[.*\..*proj]] ] = 'msbuild',
  },
})
```

Optionally tell treesitter to treat `msbuild` as `xml` so you can get syntax highlighting if you have the treesitter-xml-parser installed.

```lua
vim.treesitter.language.register('xml', { 'msbuild' })
```
]=],
  },
}
