local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.fsautocomplete = {
  default_config = {
    root_dir = util.root_pattern('*.sln', '*.fsproj', '.git');
    filetypes = {'fsharp'};
    init_options = {
      AutomaticWorkspaceInit = true;
    };
  };
  docs = {
    description = [[
https://github.com/fsharp/FsAutoComplete

Language Server for F# provided by FsAutoComplete (FSAC).

FsAutoComplete requires the [dotnet-sdk](https://dotnet.microsoft.com/download) to be installed.

With dotnet-sdk installed FsAutoComplete can be installed with `dotnet tool install --global fsautocomplete`.

Also it's possible build from source from [here](https://github.com/fsharp/FsAutoComplete/releases).
Instructions to compile from source are found on the main repository.

You may also need to configure the filetype as Vim defaults to Forth for `*.fs` files:

`autocmd BufNewFile,BufRead *.fs,*.fsx,*.fsi set filetype=fsharp`

This is automatically done by plugins such as [vim-polyglot](https://github.com/sheerun/vim-polyglot), [PhilT/vim-fsharp](https://github.com/PhilT/vim-fsharp), [fsharp/vim-fsharp](https://github.com/fsharp/vim-fsharp) or [adelarsq/neofsharp.vim](https://github.com/adelarsq/neofsharp.vim).

```lua
require'lspconfig'.fsautocomplete.setup{
  cmd = {'dotnet', 'fsautocomplete', '--background-service-enabled'}
  -- Or for custom build:
  -- cmd = {'dotnet', 'path/to/fsautocomplete.dll', '--background-service-enabled'}
}
```

```lua
require'lspconfig'.fsautocomplete.setup{}

  Commands:
  
  Default Values:
    filetypes = { "fsharp" }
    init_options = {
      AutomaticWorkspaceInit = true
    }
    root_dir = function(startpath)
        return M.search_ancestors(startpath, matcher)
      end
```
    ]];
  };
}
-- vim:et ts=2 sw=2
