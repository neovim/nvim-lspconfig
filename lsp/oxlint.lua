--- @brief
---
--- https://github.com/oxc-project/oxc
---
--- `oxc` is a linter / formatter for JavaScript / Typescript supporting over 500 rules from ESLint and its popular plugins
--- It can be installed via `npm`:
---
--- ```sh
--- npm i -g oxlint
--- ```

local util = require 'lspconfig.util'

---@type vim.lsp.Config
return {
  cmd = { 'oxlint', '--lsp' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  workspace_required = true,
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'LspOxlintFixAll', function()
      client:request_sync('workspace/executeCommand', {
        command = 'oxc.fixAll',
        arguments = {
          {
            uri = vim.uri_from_bufnr(bufnr),
          },
        },
      }, nil, bufnr)
    end, {})
  end,
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)

    -- Oxlint resolves configuration by walking upward and using the nearest config file
    -- to the file being processed. We therefore compute the root directory by locating
    -- the closest `.oxlintrc.json` (or `package.json` fallback) above the buffer.
    local root_markers = util.insert_package_json({ '.oxlintrc.json' }, 'oxlint', fname)[1]
    on_dir(vim.fs.dirname(vim.fs.find(root_markers, { path = fname, upward = true })[1]))
  end,
  init_options = {
    {
      workspaceUri = 'file://' .. vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1]),
      options = {
        -- run = 'onType',
        -- configPath = null,
        -- tsConfigPath = null,
        -- unusedDisableDirectives = 'allow',
        -- typeAware = false,
        -- disableNestedConfig = false,
        -- fixKind = 'safe_fix',
      },
    },
  },
}
