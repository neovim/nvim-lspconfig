local util = require 'lspconfig.util'

-- https://github.com/vuejs/language-tools/blob/master/packages/language-server/lib/types.ts
local volar_init_options = {
  typescript = {
    tsdk = '',
  },
}

return {
  default_config = {
    cmd = { 'vue-language-server', '--stdio' },
    filetypes = { 'vue' },
    root_dir = util.root_pattern 'package.json',
    init_options = volar_init_options,
    on_new_config = function(new_config, new_root_dir)
      if
        new_config.init_options
        and new_config.init_options.typescript
        and new_config.init_options.typescript.tsdk == ''
      then
        new_config.init_options.typescript.tsdk = util.get_typescript_server_path(new_root_dir)
      end
    end,
  },
  docs = {
    description = [[
https://github.com/vuejs/language-tools/tree/master/packages/language-server

Volar language server for Vue

Volar can be installed via npm:
```sh
npm install -g @vue/language-server
```

Volar by default supports Vue 3 projects.
For Vue 2 projects, [additional configuration](https://github.com/vuejs/language-tools/blob/master/extensions/vscode/README.md?plain=1#L19) are required.

**Hybrid Mode (by default)**

In this mode, the Vue Language Server exclusively manages the CSS/HTML sections.
You need the `ts_ls` server with the `@vue/typescript-plugin` plugin to support TypeScript in `.vue` files.
See `ts_ls` section for more information

**No Hybrid Mode**

Volar will run embedded `ts_ls` therefore there is no need to run it separately.
```lua
local lspconfig = require('lspconfig')

lspconfig.volar.setup {
  -- add filetypes for typescript, javascript and vue
  filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
  init_options = {
    vue = {
      -- disable hybrid mode
      hybridMode = false,
    },
  },
}
-- you must remove ts_ls setup
-- lspconfig.ts_ls.setup {}
```

**Overriding the default TypeScript Server used by Volar**

The default config looks for TypeScript in the local `node_modules`. This can lead to issues
e.g. when working on a [monorepo](https://monorepo.tools/). The alternatives are:

- use a global TypeScript Server installation
```lua
require'lspconfig'.volar.setup {
  init_options = {
    typescript = {
      -- replace with your global TypeScript library path
      tsdk = '/path/to/node_modules/typescript/lib'
    }
  }
}
```

- use a local server and fall back to a global TypeScript Server installation
```lua
require'lspconfig'.volar.setup {
  init_options = {
    typescript = {
      -- replace with your global TypeScript library path
      tsdk = '/path/to/node_modules/typescript/lib'
    }
  },
  on_new_config = function(new_config, new_root_dir)
    local lib_path = vim.fs.find('node_modules/typescript/lib', { path = new_root_dir, upward = true })[1]
    if lib_path then
      new_config.init_options.typescript.tsdk = lib_path
    end
  end
}
```
    ]],
  },
}
