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
    local cwd = vim.uv.cwd()
    local root = vim.fs.root(bufnr, { 'composer.json', '.git' })

    -- prefer cwd if root is a descendant
    on_dir(vim.fs.relpath(cwd, root) ~= nil and cwd or root)
  end,
}
