local util = require 'lspconfig.util'

local cmd = {
  'phan',
  '-m',
  'json',
  '--no-color',
  '--no-progress-bar',
  '-x',
  '-u',
  '-S',
  '--language-server-on-stdin',
  '--allow-polyfill-parser',
}

---@brief
---
-- https://github.com/phan/phan
--
-- Installation: https://github.com/phan/phan#getting-started
return {
  cmd = cmd,
  filetypes = { 'php' },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local cwd = vim.uv.cwd()
    local root = util.root_pattern('composer.json', '.git')(fname)

    -- prefer cwd if root is a descendant
    on_dir(util.path.is_descendant(cwd, root) and cwd or root)
  end,
}
