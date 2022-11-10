local util = require 'lspconfig.util'

local workspace_markers = { '.git' }

return {
  default_config = {
    cmd = { 'R', '--slave', '-e', 'languageserver::run()' },
    filetypes = { 'r', 'rmd' },
    root_dir = function(fname)
      -- FIXME(kylo252): why does this use homedir?
      return util.root_pattern(unpack(workspace_markers))(fname) or vim.loop.os_homedir()
    end,
    log_level = vim.lsp.protocol.MessageType.Warning,
  },
  docs = {
    description = [[
[languageserver](https://github.com/REditorSupport/languageserver) is an
implementation of the Microsoft's Language Server Protocol for the R
language.

It is released on CRAN and can be easily installed by

```R
install.packages("languageserver")
```
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
