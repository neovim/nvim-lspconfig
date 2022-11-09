local util = require 'lspconfig.util'

local workspace_markers = { 'stack.yaml', 'package.yaml', '.git' }

return {
  default_config = {
    cmd = { 'hie-wrapper', '--lsp' },
    filetypes = { 'haskell' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },

  docs = {
    description = [[
https://github.com/haskell/haskell-ide-engine

the following init_options are supported (see https://github.com/haskell/haskell-ide-engine#configuration):
```lua
init_options = {
  languageServerHaskell = {
    hlintOn = bool;
    maxNumberOfProblems = number;
    diagnosticsDebounceDuration = number;
    liquidOn = bool (default false);
    completionSnippetsOn = bool (default true);
    formatOnImportOn = bool (default true);
    formattingProvider = string (default "brittany", alternate "floskell");
  }
}
```
        ]],

    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
