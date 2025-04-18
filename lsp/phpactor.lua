---@brief
---
-- https://github.com/phpactor/phpactor
--
-- Installation: https://phpactor.readthedocs.io/en/master/usage/standalone.html#global-installation
return {
  cmd = { 'phpactor', 'language-server' },
  filetypes = { 'php' },
  root_dir = function(bufnr, on_dir)
    local cwd = vim.uv.cwd()
    local root = vim.fs.root(bufnr, { 'composer.json', '.git', '.phpactor.json', '.phpactor.yml' })

    -- prefer cwd if root is a descendant
    on_dir(vim.fs.relpath(cwd, root) ~= nil and cwd or root)
  end,
}
