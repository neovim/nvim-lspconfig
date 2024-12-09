local util = require 'lspconfig.util'

local function get_typescript_server_path(root_dir)
  local project_root = vim.fs.find('node_modules', { path = root_dir, upward = true })[1]
  return project_root and (util.path.join(project_root, 'typescript', 'lib')) or ''
end

-- https://github.com/johnsoncodehk/volar/blob/20d713b/packages/shared/src/types.ts
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
        new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
      end
    end,
  },
  docs = {
    description = [[
https://github.com/johnsoncodehk/volar/tree/20d713b/packages/vue-language-server

Volar language server for Vue

Volar can be installed via npm:

```sh
npm install -g @vue/language-server
```

Volar by default supports Vue 3 projects. Vue 2 projects need
[additional configuration](https://github.com/vuejs/language-tools/tree/master/packages/vscode-vue#usage).

**TypeScript support**
As of release 2.0.0, Volar no longer wraps around ts_ls. For typescript
support, `ts_ls` needs to be configured with the `@vue/typescript-plugin`
plugin.

**Take Over Mode**

Volar (prior to 2.0.0), can serve as a language server for both Vue and TypeScript via [Take Over Mode](https://github.com/johnsoncodehk/volar/discussions/471).

To enable Take Over Mode, override the default filetypes in `setup{}` as follows:

```lua
require'lspconfig'.volar.setup{
  filetypes = {'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json'}
}
```

**Overriding the default TypeScript Server used by Volar**

The default config looks for TS in the local `node_modules`. This can lead to issues
e.g. when working on a [monorepo](https://monorepo.tools/). The alternatives are:

- use a global TypeScript Server installation

```lua
require'lspconfig'.volar.setup{
  init_options = {
    typescript = {
      tsdk = '/path/to/.npm/lib/node_modules/typescript/lib'
      -- Alternative location if installed as root:
      -- tsdk = '/usr/local/lib/node_modules/typescript/lib'
    }
  }
}
```

- use a local server and fall back to a global TypeScript Server installation

```lua
require'lspconfig'.volar.setup{
  init_options = {
    typescript = {
      tsdk = '/path/to/.npm/lib/node_modules/typescript/lib'
      -- Alternative location if installed as root:
      -- tsdk = '/usr/local/lib/node_modules/typescript/lib'
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
