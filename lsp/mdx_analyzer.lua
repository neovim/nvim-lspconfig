---@brief
--- https://github.com/mdx-js/mdx-analyzer
---
--- `mdx-analyzer`, a language server for MDX

local function get_typescript_server_path(root_dir)
  local project_root = vim.fs.dirname(vim.fs.find('node_modules', { path = root_dir, upward = true })[1])
  return project_root and vim.fs.joinpath(project_root, 'node_modules', 'typescript', 'lib') or ''
end

return {
  cmd = { 'mdx-language-server', '--stdio' },
  filetypes = { 'mdx' },
  root_markers = { 'package.json' },
  settings = {},
  init_options = {
    typescript = {},
  },
  before_init = function(_, config)
    if config.init_options and config.init_options.typescript and not config.init_options.typescript.tsdk then
      config.init_options.typescript.tsdk = get_typescript_server_path(config.root_dir)
    end
  end,
}
