---@brief
---
-- https://github.com/landeaux/vscode-smarty-langserver-extracted
--
-- Language server for Smarty.
--
-- `smarty-language-server` can be installed via `npm`:
--
-- ```sh
-- npm i -g vscode-smarty-langserver-extracted
-- ```
return {
  cmd = { 'smarty-language-server', '--stdio' },
  filetypes = { 'smarty' },
  root_dir = function(bufnr, on_dir)
    local cwd = vim.uv.cwd()
    local root = vim.fs.root(bufnr, { 'composer.json', '.git' })

    -- prefer cwd if root is a descendant
    on_dir(vim.fs.relpath(cwd, root) ~= nil and cwd or root)
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
