local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'twig-language-server', '--stdio' },
    filetypes = { 'twig' },
    root_dir = util.root_pattern('composer.json', '.git'),
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/moetelo/twiggy

Can be installed via Mason, which uses the server bundled with the VSCode extension.
```
]],
    default_config = {
      root_dir = [[root_pattern("composer.json", ".git")]],
    },
  },
}
