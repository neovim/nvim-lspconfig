--- @brief
---
--- https://github.com/oxc-project/oxc
--- https://oxc.rs/docs/guide/usage/formatter.html
---
--- `oxfmt` is a Prettier-compatible code formatter for JavaScript / Typescript.
--- It can be installed via `npm`:
---
--- ```sh
--- npm i -g oxfmt
--- ```

local util = require 'lspconfig.util'

---@type vim.lsp.Config
return {
  cmd = { 'oxfmt', '--lsp' },
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

    -- Oxfmt resolves configuration by walking upward and using the nearest config file
    -- to the file being processed. We therefore compute the root directory by locating
    -- the closest `.oxfmtrc.json` (or `package.json` fallback) above the buffer.
    local root_markers = util.insert_package_json({ '.oxfmtrc.json' }, 'oxfmt', fname)[1]
    on_dir(vim.fs.dirname(vim.fs.find(root_markers, { path = fname, upward = true })[1]))
  end,
  before_init = function(_, config)
    config.settings = {
      {
        workspaceUri = config.root_dir,
        options = {
          ['fmt.experimental'] = true, -- if disable the Oxfmt LS won't do anything
          -- ['fmt.configPath'] = null,
        },
      },
    }
  end,
}
