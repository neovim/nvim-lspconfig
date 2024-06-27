local util = require 'lspconfig.util'

local root_files = {
  'pyproject.toml',
  'ruff.toml',
  '.ruff.toml',
}

return {
  default_config = {
    cmd = { 'ruff', 'server' },
    filetypes = { 'python' },
    root_dir = util.root_pattern(unpack(root_files)) or util.find_git_ancestor(),
    single_file_support = true,
    settings = {},
  },
  docs = {
    description = [[
https://github.com/astral-sh/ruff

A Language Server Protocol implementation for Ruff, an extremely fast Python linter and code formatter, written in Rust. It can be installed via `pip`.

```sh
pip install ruff
```

**Available in Ruff `v0.4.5` in beta and stabilized in Ruff `v0.5.3`.**

This is the new built-in language server written in Rust. It supports the same feature set as `ruff-lsp`, but with superior performance and no installation required. Note that the `ruff-lsp` server will continue to be maintained until further notice.

Server settings can be provided via:

```lua
require('lspconfig').ruff.setup({
  init_options = {
    settings = {
      -- Server settings should go here
    }
  }
})

Refer to the [documentation](https://docs.astral.sh/ruff/editors/) for more details.
```

  ]],
    root_dir = [[root_pattern("pyproject.toml", "ruff.toml", ".ruff.toml", ".git")]],
  },
}
