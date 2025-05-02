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

return {
  cmd = { 'oxc_language_server' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  workspace_required = true,
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root_markers = util.insert_package_json({ '.oxlintrc.json' }, 'oxlint', fname)
    on_dir(vim.fs.dirname(vim.fs.find(root_markers, { path = fname, upward = true })[1]))
  end,
}
