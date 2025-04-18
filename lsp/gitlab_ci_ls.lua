---@brief
---
--- https://github.com/alesbrelih/gitlab-ci-ls
---
--- Language Server for Gitlab CI
---
--- `gitlab-ci-ls` can be installed via cargo:
--- cargo install gitlab-ci-ls

local util = require 'lspconfig.util'

local cache_dir = vim.uv.os_homedir() .. '/.cache/gitlab-ci-ls/'

return {
  cmd = { 'gitlab-ci-ls' },
  filetypes = { 'yaml.gitlab' },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    on_dir(util.root_pattern('.gitlab*', '.git')(fname))
  end,
  init_options = {
    cache_path = cache_dir,
    log_path = cache_dir .. '/log/gitlab-ci-ls.log',
  },
}
