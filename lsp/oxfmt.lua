--- @brief
---
--- https://github.com/oxc-project/oxc
--- https://oxc.rs/docs/guide/usage/formatter.html
---
--- `oxfmt` is a Prettier-compatible code formatter that supports multiple languages
--- including JavaScript, TypeScript, JSON, YAML, HTML, CSS, Markdown, and more.
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
    'toml',
    'json',
    'jsonc',
    'json5',
    'yaml',
    'html',
    'vue',
    'handlebars',
    'hbs',
    'css',
    'scss',
    'less',
    'graphql',
    'markdown',
    'mdx',
  },
  workspace_required = true,
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)

    -- Oxfmt resolves configuration by walking upward and using the nearest config file
    -- to the file being processed. We therefore compute the root directory by locating
    -- the closest `.oxfmtrc.json` / `.oxfmtrc.jsonc` (or `package.json` fallback) above the buffer.
    local root_markers = util.insert_package_json({ '.oxfmtrc.json', '.oxfmtrc.jsonc' }, 'oxfmt', fname)
    on_dir(vim.fs.dirname(vim.fs.find(root_markers, { path = fname, upward = true })[1]))
  end,
}
