local util = require 'lspconfig.util'

local bin_name = 'stylelint-lsp'
local cmd = { bin_name, '--stdio' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, '--stdio' }
end

local workspace_markers = { '.stylelintrc', 'package.json' }

return {
  default_config = {
    cmd = cmd,
    filetypes = {
      workspace_markers = workspace_markers,
      'css',
      'less',
      'scss',
      'sugarss',
      'vue',
      'wxss',
      'javascript',
      'javascriptreact',
      'typescript',
      'typescriptreact',
    },
    root_dir = util.root_pattern(unpack(workspace_markers)),
    settings = {},
  },
  docs = {
    description = [[
https://github.com/bmatcuk/stylelint-lsp

`stylelint-lsp` can be installed via `npm`:

```sh
npm i -g stylelint-lsp
```

Can be configured by passing a `settings.stylelintplus` object to `stylelint_lsp.setup`:

```lua
require'lspconfig'.stylelint_lsp.setup{
  settings = {
    stylelintplus = {
      -- see available options in stylelint-lsp documentation
    }
  }
}
```
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
