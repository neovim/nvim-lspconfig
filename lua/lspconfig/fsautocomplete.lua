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

Language Server for F# provded by FsAutoComplete (FSAC).

Download a release of FsAutoComplete from [here](https://github.com/fsharp/FsAutoComplete/releases).
Instructions to compile from source are found on the main repository.

FsAutoComplete requires the [dotnet-sdk](https://dotnet.microsoft.com/download) to be installed.

You may also need to configure the filetype as Vim defaults to Forth for `*.fs` files:

`autocmd BufNewFile,BufRead *.fs,*.fsx,*.fsi set filetype=fsharp`

This is automatically done by plugins such as [vim-polyglot](https://github.com/sheerun/vim-polyglot), [PhilT/vim-fsharp](https://github.com/PhilT/vim-fsharp) or [fsharp/vim-fsharp](https://github.com/fsharp/vim-fsharp).

**By default, this config doesn't have a `cmd` set.** This is because nvim-lspconfig does not make assumptions about your path. You must add the following to your init.vim or init.lua to set `cmd` to the absolute path ($HOME and ~ are not expanded) of your unzipped and compiled fsautocomplete.dll.

```lua
require'lspconfig'.fsautocomplete.setup{
  cmd = {'dotnet', 'path/to/fsautocomplete.dll', '--background-service-enabled'}
}
```
    ]];
  };
}
-- vim:et ts=2 sw=2
