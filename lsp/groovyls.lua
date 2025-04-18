---@brief
---
--- https://github.com/prominic/groovy-language-server.git
---
--- Requirements:
---  - Linux/macOS (for now)
---  - Java 11+
---
--- `groovyls` can be installed by following the instructions [here](https://github.com/prominic/groovy-language-server.git#build).
---
--- If you have installed groovy language server, you can set the `cmd` custom path as follow:
---
--- ```lua
--- vim.lsp.config('groovyls', {
---     -- Unix
---     cmd = { "java", "-jar", "path/to/groovyls/groovy-language-server-all.jar" },
---     ...
--- })
--- ```
return {
  cmd = {
    'java',
    '-jar',
    'groovy-language-server-all.jar',
  },
  filetypes = { 'groovy' },
  root_markers = { 'Jenkinsfile', '.git' },
}
