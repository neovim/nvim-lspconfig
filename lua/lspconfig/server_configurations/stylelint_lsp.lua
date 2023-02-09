local util = require 'lspconfig.util'
local is_windows = vim.fn.has 'win32' == 1

local bin_name = 'stylelint-lsp'
local cmd = { bin_name, '--stdio' }

if is_windows == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, '--stdio' }
end

local root_file = {
  '.stylelintrc',
  '.stylelintrc.cjs',
  '.stylelintrc.js',
  '.stylelintrc.json',
  '.stylelintrc.yaml',
  '.stylelintrc.yml',
  'stylelint.config.cjs',
  'stylelint.config.js',
}

local root_with_package = util.find_package_json_ancestor(vim.fn.expand '%:p:h')

if root_with_package then
  -- only add package.json if it contains stylelint field
  local path_sep = is_windows and '\\' or '/'
  for line in io.lines(root_with_package .. path_sep .. 'package.json') do
    if line:find 'stylelint' then
      table.insert(root_file, 'package.json')
      break
    end
  end
end

return {
  default_config = {
    cmd = cmd,
    filetypes = {
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
    root_dir = util.root_pattern(unpack(root_file)),
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
  },
}
