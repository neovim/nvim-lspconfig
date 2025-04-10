local util = require 'lspconfig.util'

local cache_dir = vim.uv.os_homedir() .. '/.cache/gitlab-ci-ls/'
return {
  default_config = {
    cmd = { 'gitlab-ci-ls' },
    filetypes = { 'yaml.gitlab' },
    root_dir = util.root_pattern('.gitlab*', '.git'),
    init_options = {
      cache_path = cache_dir,
      log_path = cache_dir .. '/log/gitlab-ci-ls.log',
    },
  },
  docs = {
    description = [[
https://github.com/alesbrelih/gitlab-ci-ls

Language Server for Gitlab CI

`gitlab-ci-ls` can be installed via cargo:
cargo install gitlab-ci-ls
]],
  },
}
