local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = {
      'java',
      '-jar',
      'groovy-language-server-all.jar',
    },
    filetypes = { 'groovy' },
    root_dir = function(fname)
      return util.root_pattern 'Jenkinsfile'(fname)
        or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
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
  },
}
