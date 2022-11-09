local util = require 'lspconfig.util'

local bin_name = 'psalm-language-server'

if vim.fn.has 'win32' == 1 then
  bin_name = bin_name .. '.bat'
end

local workspace_markers = { 'psalm.xml', 'psalm.xml.dist' }

return {
  default_config = {
    cmd = { bin_name },
    filetypes = { 'php' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  docs = {
    description = [[
https://github.com/vimeo/psalm

Can be installed with composer.
```sh
composer global require vimeo/psalm
```
]],
    default_config = {
      cmd = { 'psalm-language-server' },
      workspace_markers = workspace_markers,
    },
  },
}
