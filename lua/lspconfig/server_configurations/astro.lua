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

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'astro' },
    root_dir = util.root_pattern('package.json', 'tsconfig.json', 'jsconfig.json', '.git'),
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

To use `tsserver` integration, you need to install it via `npm`:
```sh
npm install -g typescript
```

Then configure `astro-ls` to use `typescript.js` file which comes with `typescript` package. It's locaed in `lib/typescript.js`:

```lua
require 'lspconfig'.astro.setup {
  init_options = {
    typescript = {
      serverPath = "<YOUR_PATH_TO_GLOBAL_NPM_PACKAGES>/node_modules/typescript/lib/typescript.js"
    },
  },
}
```
]],
    default_config = {
      root_dir = [[root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git")]],
    },
  },
}
