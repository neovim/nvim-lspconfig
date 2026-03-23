---@brief
---
--- https://github.com/stylelint/vscode-stylelint/tree/main/packages/language-server
---
--- `stylelint-language-server` can be installed via npm `npm install -g @stylelint/language-server`.
--- ```

local util = require 'lspconfig.util'
local lsp = vim.lsp

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
    'vue',
  },
  root_markers = root_file,
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'LspStylelintFixAll', function()
      client:request_sync('workspace/executeCommand', {
        command = 'stylelint.applyAutoFix',
        arguments = {
          {
            uri = vim.uri_from_bufnr(bufnr),
            version = lsp.util.buf_versions[bufnr],
          },
        },
      }, nil, bufnr)
    end, {})
  end,
  -- Refer to https://github.com/stylelint/vscode-stylelint?tab=readme-ov-file#extension-settings for documentation.
  ---@type lspconfig.settings.stylelint_language_server
  settings = {
    stylelint = {
      validate = { 'css', 'postcss' },
      snippet = { 'css', 'postcss' },
    },
  },
}
