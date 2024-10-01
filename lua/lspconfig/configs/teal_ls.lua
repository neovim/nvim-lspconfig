local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = {
      'teal-language-server',
    },
    filetypes = {
      'teal',
    },
    root_dir = util.root_pattern 'tlconfig.lua',
  },
  docs = {
    description = [[
https://github.com/teal-language/teal-language-server

Install with:
```
luarocks install teal-language-server
```

Optional Command Args:
* "--log-mode=by_date" - Enable logging in $HOME/.cache/teal-language-server. Log name will be date + pid of process
* "--log-mode=by_proj_path" - Enable logging in $HOME/.cache/teal-language-server. Log name will be project path + pid of process
* "--verbose=true" - Increases log level.  Does nothing unless log-mode is set
]],
    default_config = {
      root_dir = [[root_pattern("tlconfig.lua")]],
    },
  },
}
