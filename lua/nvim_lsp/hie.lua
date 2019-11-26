local skeleton = require 'nvim_lsp/skeleton'
local util = require 'nvim_lsp/util'
local lsp = vim.lsp

skeleton.hie = {
  default_config = {
    cmd = {"hie-wrapper"};
    filetypes = {"haskell"};
    root_dir = util.root_pattern("stack.yaml", "package.yaml", ".git");
    log_level = lsp.protocol.MessageType.Warning;
    settings = {};
  };

  docs = {
    vscode = "alanz.vscode-hie-server";
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
        ]];

    default_config = {
      root_dir = [[root_pattern("stack.yaml", "package.yaml", ".git")]];
    };
  };
};

-- vim:et ts=2 sw=2
