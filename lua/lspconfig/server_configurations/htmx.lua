local util = require 'lspconfig.util'
-- NOTE: the binary can be installed in custom a location. The user should
-- change the cmd to match the installation path
local cargo_home = os.getenv("CARGO_INSTALL_ROOT") or os.getenv("CARGO_HOME") or os.getenv("HOME") .. "/.cargo"

return {
  default_config = {
    cmd = { cargo_home .. "/bin/htmx-lsp" },
    filetypes = { "html" },
    root_dir = function(fname)
      return util.find_git_ancestor(fname) or vim.fn.expand("%:p:h") or vim.loop.os_homedir()
    end,
    settings = {},
  },
  docs = {
    description = [[
https://github.com/ThePrimeagen/htmx-lsp

`htmx-lsp` can be installed via `cargo`:
```sh
cargo install htmx-lsp
```

Lsp is still very much work in progress and experimental. Use at your own risk.
]],
  },
}
