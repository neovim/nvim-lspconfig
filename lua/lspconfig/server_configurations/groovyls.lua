local util = require 'lspconfig.util'

local workspace_markers = { 'Jenkinsfile', '.git' }

return {
  default_config = {
    cmd = {
      'java',
      '-jar',
      'groovy-language-server-all.jar',
    },
    filetypes = { 'groovy' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  docs = {
    description = [[
https://github.com/prominic/groovy-language-server.git

Requirements:
 - Linux/macOS (for now)
 - Java 11+

`groovyls` can be installed by following the instructions [here](https://github.com/prominic/groovy-language-server.git#build).

If you have installed groovy language server, you can set the `cmd` custom path as follow:

```lua
require'lspconfig'.groovyls.setup{
    -- Unix
    cmd = { "java", "-jar", "path/to/groovyls/groovy-language-server-all.jar" },
    ...
}
```
]],
    workspace_markers = workspace_markers,
  },
}
