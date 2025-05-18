-- lua/lspconfig/configs/ty.lua

local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'ty', 'server' },
    filetypes = { 'python' },
    root_dir = function(fname)
      return util.root_pattern('ty.toml', 'pyproject.toml', '.git')(fname)
    end,
  },
  docs = {
    description = [[
https://github.com/astral-sh/ty
`ty`, a static type checker and language server for python.
The language server can be installed with `uv`: `uv tool install ty`
]],
  },
}
