local util = require 'lspconfig.util'

local bin_name = 'astro-ls'
local cmd = { bin_name, '--stdio' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, '--stdio' }
end

local function get_typescript_server_path(root_dir)
  local project_root = util.find_node_modules_ancestor(root_dir)
  return project_root and (util.path.join(project_root, 'node_modules', 'typescript', 'lib', 'tsserverlibrary.js'))
    or ''
end

local workspace_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' }

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'astro' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
    init_options = {
      typescript = {
        serverPath = '',
      },
      configuration = {},
    },
    on_new_config = function(new_config, new_root_dir)
      if
        new_config.init_options
        and new_config.init_options.typescript
        and new_config.init_options.typescript.serverPath == ''
      then
        new_config.init_options.typescript.serverPath = get_typescript_server_path(new_root_dir)
      end
    end,
  },
  docs = {
    description = [[
https://github.com/withastro/language-tools/tree/main/packages/language-server

`astro-ls` can be installed via `npm`:
```sh
npm install -g @astrojs/language-server
```
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
