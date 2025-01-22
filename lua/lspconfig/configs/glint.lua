local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'glint-language-server' },
    on_new_config = function(config, new_root_dir)
      local project_root = vim.fs.dirname(vim.fs.find('node_modules', { path = new_root_dir, upward = true })[1])
      -- Glint should not be installed globally.
      local node_bin_path = project_root .. '/node_modules/.bin'
      local path = node_bin_path .. (vim.fn.has('win32') == 1 and ';' or ':') .. vim.env.PATH
      if config.cmd_env then
        config.cmd_env.PATH = path
      else
        config.cmd_env = { PATH = path }
      end
    end,
    filetypes = {
      'html.handlebars',
      'handlebars',
      'typescript',
      'typescript.glimmer',
      'javascript',
      'javascript.glimmer',
    },
    root_dir = util.root_pattern(
      '.glintrc.yml',
      '.glintrc',
      '.glintrc.json',
      '.glintrc.js',
      'glint.config.js',
      'package.json'
    ),
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
