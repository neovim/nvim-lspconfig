local util = require 'lspconfig.util'

local bin_name = 'vls'
local cmd = { bin_name }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name }
end

local workspace_markers = { 'package.json', 'vue.config.js' }

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'vue' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
    init_options = {
      config = {
        vetur = {
          useWorkspaceDependencies = false,
          validation = {
            template = true,
            style = true,
            script = true,
          },
          completion = {
            autoImport = false,
            useScaffoldSnippets = false,
            tagCasing = 'kebab',
          },
          format = {
            defaultFormatter = {
              js = 'none',
              ts = 'none',
            },
            defaultFormatterOptions = {},
            scriptInitialIndent = false,
            styleInitialIndent = false,
          },
        },
        css = {},
        html = {
          suggest = {},
        },
        javascript = {
          format = {},
        },
        typescript = {
          format = {},
        },
        emmet = {},
        stylusSupremacy = {},
      },
    },
  },
  docs = {
    description = [[
https://github.com/vuejs/vetur/tree/master/server

Vue language server(vls)
`vue-language-server` can be installed via `npm`:
```sh
npm install -g vls
```
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
