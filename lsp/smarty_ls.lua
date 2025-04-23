---@brief
---
--- https://github.com/landeaux/vscode-smarty-langserver-extracted
---
--- Language server for Smarty.
---
--- `smarty-language-server` can be installed via `npm`:
---
--- ```sh
--- npm i -g vscode-smarty-langserver-extracted
--- ```

local util = require 'lspconfig.util'

return {
  cmd = { 'smarty-language-server', '--stdio' },
  filetypes = { 'smarty' },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local cwd = assert(vim.uv.cwd())
    local root = util.root_pattern('composer.json', '.git')(fname)

    -- prefer cwd if root is a descendant
    on_dir(vim.fs.relpath(cwd, root) and cwd or root)
  end,
  settings = {
    smarty = {
      pluginDirs = {},
    },
    css = {
      validate = true,
    },
  },
  init_options = {
    storageDir = nil,
  },
}
