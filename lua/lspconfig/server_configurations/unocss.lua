local util = require 'lspconfig.util'

local bin_name = 'unocss-language-server'
local cmd = { bin_name, '--stdio' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, '--stdio' }
end

return {
  default_config = {
    cmd = cmd,
    filetypes = {
      'html',
      'javascriptreact',
      'rescript',
      'typescriptreact',
      'vue',
      'svelte',
    },
    root_dir = function(fname)
      return util.root_pattern('unocss.config.js', 'unocss.config.ts')(fname)
    end,
  },
  docs = {
    description = [[
https://github.com/xna00/unocss-language-server

UnoCSS Language Server can be installed via npm:
```sh
npm i unocss-language-server -g
```
]],
    default_config = {
      root_dir = [[root_pattern('unocss.config.js', 'unocss.config.ts')]],
    },
  },
}
