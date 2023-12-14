local util = require 'lspconfig.util'

local cmd = {
  'psalm',
  '--language-server',
}

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'php' },
    root_dir = util.root_pattern('psalm.xml', 'psalm.xml.dist'),
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
      cmd = cmd,
      root_dir = [[root_pattern("psalm.xml", "psalm.xml.dist")]],
    },
  },
}
