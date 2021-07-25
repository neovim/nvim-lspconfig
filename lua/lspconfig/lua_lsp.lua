local configs = require 'lspconfig/configs'

local server_name = 'lua_lsp'
local bin_name = 'lua-lsp'

configs[server_name] = {
  default_config = {
    cmd = { bin_name },
    filetypes = { 'lua' },
    root_dir = function(fname)
      return vim.fn.getcwd()
    end,
  },
  docs = {
    description = [[
https://github.com/Alloyed/lua-lsp

`lua-lsp` can be installed with:
```
luarocks install --server=http://luarocks.org/dev lua-lsp
```
Note that only supports lua versions from 5.1-5.3
]],
    default_config = {
      root_dir = "vim's starting directory",
    },
  },
}

-- vim:et ts=2 sw=2
