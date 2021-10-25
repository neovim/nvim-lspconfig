local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local name = 'sumneko_lua'

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

configs[name] = {
  default_config = {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_dir = function(fname)
      return util.find_git_ancestor(fname) or util.path.dirname(fname)
    end,
    log_level = vim.lsp.protocol.MessageType.Warning,
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
          -- Setup your lua path
          path = runtime_path,
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { 'vim' },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file('', true),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  },
  docs = {
    package_json = 'https://raw.githubusercontent.com/sumneko/vscode-lua/master/package.json',
    description = [[
https://github.com/sumneko/lua-language-server

`lua-language-server` can be installed from your system's package manager if available, or from source by following the instructions [here](https://github.com/sumneko/lua-language-server/wiki/Build-and-Run-(Standalone)).

If installing from your system's package manager, `lua-language-server` should already be on your path, and the default `cmd` should work.

If installing from source, you can either add `/path/to/lua-language-server/bin/Linux` (or Windows, macOS) to your path, or set `cmd` in the server `setup{}` call.

```
require'lspconfig'.sumneko_lua.setup {
  -- note, substitute Linux for Windows or macOS
  cmd = { "/path/to/lua-language-server/bin/Linux/lua-language-server"};
}
```

]],
    default_config = {
      root_dir = [[root_pattern(".git") or bufdir]],
    },
  },
}
