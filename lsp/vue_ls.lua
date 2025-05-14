---@brief
---
--- https://github.com/vuejs/language-tools/tree/master/packages/language-server
---
--- The official language server for Vue
---
--- It can be installed via npm:
--- ```sh
--- npm install -g @vue/language-server
--- ```
---
--- The language server only supports Vue 3 projects by default.
--- For Vue 2 projects, [additional configuration](https://github.com/vuejs/language-tools/blob/master/extensions/vscode/README.md?plain=1#L19) are required.
---
--- **Hybrid Mode (by default)**
---
--- In this mode, the Vue Language Server exclusively manages the CSS/HTML sections.
--- You need the `ts_ls` server with the `@vue/typescript-plugin` plugin to support TypeScript in `.vue` files.
--- See `ts_ls` section for more information
---
--- **No Hybrid Mode**
---
--- The Vue language server will run embedded `ts_ls` therefore there is no need to run it separately.
--- ```lua
--- vim.lsp.config('vue_ls', {
---   -- add filetypes for typescript, javascript and vue
---   filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
---   init_options = {
---     vue = {
---       -- disable hybrid mode
---       hybridMode = false,
---     },
---   },
--- })
--- -- you must remove "ts_ls" config
--- -- vim.lsp.config['ts_ls'] = {}
--- ```
---
--- **Overriding the default TypeScript Server used by the Vue language server**
---
--- The default config looks for TypeScript in the local `node_modules`. This can lead to issues
--- e.g. when working on a [monorepo](https://monorepo.tools/). The alternatives are:
---
--- - use a global TypeScript Server installation
--- ```lua
--- vim.lsp.config('vue_ls', {
---   init_options = {
---     typescript = {
---       -- replace with your global TypeScript library path
---       tsdk = '/path/to/node_modules/typescript/lib'
---     }
---   }
--- })
--- ```
---
--- - use a local server and fall back to a global TypeScript Server installation
--- ```lua
--- vim.lsp.config('vue_ls', {
---   init_options = {
---     typescript = {
---       -- replace with your global TypeScript library path
---       tsdk = '/path/to/node_modules/typescript/lib'
---     }
---   },
---   before_init = function(params, config)
---     local lib_path = vim.fs.find('node_modules/typescript/lib', { path = new_root_dir, upward = true })[1]
---     if lib_path then
---       config.init_options.typescript.tsdk = lib_path
---     end
---   end
--- })
--- ```

local util = require 'lspconfig.util'

return {
  cmd = { 'vue-language-server', '--stdio' },
  filetypes = { 'vue' },
  root_markers = { 'package.json' },
  -- https://github.com/vuejs/language-tools/blob/v2/packages/language-server/lib/types.ts
  init_options = {
    typescript = {
      tsdk = '',
    },
  },
  before_init = function(_, config)
    if config.init_options and config.init_options.typescript and config.init_options.typescript.tsdk == '' then
      config.init_options.typescript.tsdk = util.get_typescript_server_path(config.root_dir)
    end
  end,
}
