local util = require 'lspconfig.util'

local bin_name = 'glint-language-server'

-- Glint should not be installed globally.
local path_to_node_modules = util.find_node_modules_ancestor(vim.fn.getcwd())

local cmd = { path_to_node_modules .. '/node_modules/.bin/' .. bin_name }

return {
  default_config = {
    cmd = cmd,
    filetypes = {
      'html.handlebars',
      'handlebars',
      'typescript',
      'typescript.glimmer',
      'javascript',
      'javascript.glimmer',
    },
    root_dir = util.root_pattern '.glintrc.yml',
  },
  docs = {
    description = [[
  https://github.com/typed-ember/glint

  https://typed-ember.gitbook.io/glint/

  `glint-language-server` is installed when adding `@glint/core` to your project's devDependencies:

  ```sh
  npm install @glint/core --save-dev
  ```

  or

  ```sh
  yarn add -D @glint/core
  ```

  or

  ```sh
  pnpm add -D @glint/core
  ```
]],
  },
}
