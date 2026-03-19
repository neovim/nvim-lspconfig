---@brief
---
--- https://github.com/stylelint/vscode-stylelint/tree/main/packages/language-server
---
--- `stylelint-language-server` can be installed via npm `npm install -g @stylelint/language-server`.
--- ```

local util = require 'lspconfig.util'

local root_file = {
  '.stylelintrc',
  '.stylelintrc.mjs',
  '.stylelintrc.cjs',
  '.stylelintrc.js',
  '.stylelintrc.json',
  '.stylelintrc.yaml',
  '.stylelintrc.yml',
  'stylelint.config.mjs',
  'stylelint.config.cjs',
  'stylelint.config.js',
}

root_file = util.insert_package_json(root_file, 'stylelint')

---@type vim.lsp.Config
return {
  cmd = { 'stylelint-language-server', '--stdio' },
  filetypes = {
    'astro',
    'css',
    'html',
    'less',
    'scss',
    'sugarss',
    'vue',
    'wxss',
  },
  root_markers = root_file,
  -- Refer to https://github.com/stylelint/vscode-stylelint?tab=readme-ov-file#extension-settings for documentation.
  ---@type lspconfig.settings.stylelint_language_server
  settings = {},
}
