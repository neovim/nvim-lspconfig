local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.alloyed_lua = {
  default_config = {
    cmd = {'lua-lsp'};
    filetypes = {'lua'};
    root_dir = function(fname)
      return util.root_pattern('.luacheckrc', '.luacompleterc', '.git') or
        util.path.dirname(fname)
    end;
  };
  docs = {
    description = [[
https://github.com/Alloyed/lua-lsp

`lua-lsp` is a language server for Lua written in Lua. It can be installed
using *luarocks*:
```sh
luarocks install --server=http://luarocks.org/dev lua-lsp
```

`lua-lsp` automatically integrates with common lua packages when they are
installed. For linting, install `luacheck`:
```sh
luarocks install luacheck
```
    ]];
    default_config = {
      root_dir = [[root_pattern('.luacheckrc', '.luacompleterc', '.git') or dirname]];
    };
  };
};
