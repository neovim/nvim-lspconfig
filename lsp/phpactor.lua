---@brief
---
--- https://github.com/phpactor/phpactor
---
--- Installation: https://phpactor.readthedocs.io/en/master/usage/standalone.html#global-installation

local util = require 'lspconfig.util'

return {
  cmd = { 'phpactor', 'language-server' },
  filetypes = { 'php' },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local cwd = assert(vim.uv.cwd())
    local root = util.root_pattern('composer.json', '.git', '.phpactor.json', '.phpactor.yml')(fname)

    -- prefer cwd if root is a descendant
    on_dir(vim.fs.relpath(cwd, root) and cwd or root)
  end,
}
