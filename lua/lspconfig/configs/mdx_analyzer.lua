local util = require 'lspconfig.util'

local function get_typescript_server_path(root_dir)
  local project_roots = vim.fs.find('node_modules', { path = root_dir, upward = true, limit = math.huge })
  for _, project_root in ipairs(project_roots) do
    local typescript_path = project_root .. '/typescript'
    local stat = vim.loop.fs_stat(typescript_path)
    if stat and stat.type == 'directory' then
      return typescript_path .. '/lib'
    end
  end
  return ''
end

return {
  default_config = {
    cmd = { 'mdx-language-server', '--stdio' },
    filetypes = { 'mdx' },
    root_dir = util.root_pattern 'package.json',
    single_file_support = true,
    settings = {},
    init_options = {
      typescript = {},
    },
    on_new_config = function(new_config, new_root_dir)
      if vim.tbl_get(new_config.init_options, 'typescript') and not new_config.init_options.typescript.tsdk then
        new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
      end
    end,
  },
  commands = {},
  docs = {
    description = [[
https://github.com/mdx-js/mdx-analyzer

`mdx-analyzer`, a language server for MDX
]],
  },
}
