local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local name = "sumneko_lua"

configs[name] = {
  default_config = {
    filetypes = {'lua'};
    root_dir = function(fname)
      return util.find_git_ancestor(fname) or util.path.dirname(fname)
    end;
    log_level = vim.lsp.protocol.MessageType.Warning;
  };
  docs = {
    package_json = "https://raw.githubusercontent.com/sumneko/vscode-lua/master/package.json";
    description = [[
https://github.com/sumneko/lua-language-server

Lua language server.

`lua-language-server` can be installed by following the instructions [here](https://github.com/sumneko/lua-language-server/wiki/Build-and-Run-(Standalone)).

**By default, lua-language-server doesn't have a `cmd` set.** This is because nvim-lspconfig does not make assumptions about your path. You must add the following to your init.vim or init.lua to set `cmd` to the absolute path ($HOME and ~ are not expanded) of you unzipped and compiled lua-language-server.

```lua
local sumneko_root_path = "/path/to/lua-language-server"
require'lspconfig'.sumneko_lua.setup {
  cmd = {sumneko_root_path .. "/bin/{linux,macOS}/lua-language-server", "-E", sumneko_root_path .. "/main.lua"};
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
      },
    },
  },
}
```
]];
    default_config = {
      root_dir = [[root_pattern(".git") or bufdir]];
    };
  };
}
-- vim:et ts=2
