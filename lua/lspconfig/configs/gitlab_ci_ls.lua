local cache_dir = vim.loop.os_homedir() .. '/.cache/gitlab-ci-ls/'
return {
  default_config = {
    cmd = { 'gitlab-ci-ls' },
    filetypes = { 'yaml.gitlab' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ '.gitlab*', '.git' }, { path = fname, upward = true })[1])
    end,
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
