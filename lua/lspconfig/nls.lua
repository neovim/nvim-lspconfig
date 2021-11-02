local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.nls = {
    default_config = {
        cmd = {'nls'},
        filetypes = {'ncl', 'nickel'},
        root_dir = function(fname)
            return util.find_git_ancestor(fname) or util.path.dirname(fname)
        end
    },

    docs = {
        description = [[
Nickel Language Server

https://github.com/tweag/nickel

`nls` can be installed with cargo from the Nickel repository.
```sh
git clone https://github.com/tweag/nickel.git
cd nickel/lsp/nls
cargo install --path .
```

```vim
augroup filetype_nickel
  autocmd!
  autocmd BufReadPost *.ncl setlocal filetype=nickel
  autocmd BufReadPost *.nickel setlocal filetype=nickel
augroup END
```

**Snippet to enable the language server:**
```lua
require'lspconfig'.nls.setup{}
```

**Commands and default values:**
```lua
  Commands:

  Default Values:
    cmd = { "nls" }
    filetypes = { "ncl", "nickel" }
    root_dir = function(fname)
          return util.find_git_ancestor(fname) or util.path.dirname(fname)
        end,
```
        ]],

        default_config = {
            root_dir = [[util.find_git_ancestor(fname) or util.path.dirname(fname)]]
        }
    }
}
