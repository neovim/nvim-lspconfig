local util = require 'lspconfig.util'

return {
  default_config = {
    init_options = { hostInfo = 'neovim' },
    cmd = { 'scarb-cairo-language-server', '/C', '--node-ipc' },
    filetypes = { 'cairo' },
    root_dir = util.root_pattern('Scarb.toml', 'cairo_project.toml', '.git'),
  },
  docs = {
    description = [[
[Cairo Language Server](https://github.com/starkware-libs/cairo/tree/main/crates/cairo-lang-language-server)

First, install Cairo following [this tutorial](https://book.cairo-lang.org/ch01-01-installation.html)

Then enable Cairo Language Server in your Lua configuration.
```lua
require'lspconfig'.cairo_ls.setup{}
```

*cairo-language-server is still under active development, some features might not work yet !*
]],
    default_config = {
      root_dir = [[root_pattern("Scarb.toml", "cairo_project.toml", ".git")]],
    },
  },
}
