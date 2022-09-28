local util = require "lspconfig.util"

return {
  default_config = {
    cmd = { "els" },
    filetypes = { "erg" },
    root_dir = util.find_git_ancestor,
  },
  docs = {
    description = [[
https://github.com/erg-lang/erg-language-server

ELS (erg-language-server) is a language server for the Erg programing language.

`els` can be installed via `cargo`:
 ```sh
 cargo install els
 ```
    ]],
    default_config = {
      root_dir = [[util.find_git_ancestor]],
    },
  },
}
