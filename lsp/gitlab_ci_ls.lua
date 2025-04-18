local cache_dir = vim.uv.os_homedir() .. '/.cache/gitlab-ci-ls/'

---@brief
---
-- https://github.com/alesbrelih/gitlab-ci-ls
--
-- Language Server for Gitlab CI
--
-- `gitlab-ci-ls` can be installed via cargo:
-- cargo install gitlab-ci-ls
return {
  cmd = { 'gitlab-ci-ls' },
  filetypes = { 'yaml.gitlab' },
  root_markers = function(name, _)
    local patterns = { '.gitlab*', '.git' }
    for _, pattern in ipairs(patterns) do
      if vim.glob.to_lpeg(pattern):match(name) ~= nil then
        return true
      end
    end
    return false
  end,
  init_options = {
    cache_path = cache_dir,
    log_path = cache_dir .. '/log/gitlab-ci-ls.log',
  },
}
