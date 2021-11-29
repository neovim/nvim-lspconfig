local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'golangci-lint-langserver' },
    filetypes = { 'go', 'gomod' },
    init_options = {
      command = { "golangci-lint", "run", "--enable-all", "--disable", "lll", "--out-format", "json" };
    },
    root_dir = function(fname)
      return util.root_pattern 'go.work'(fname) or util.root_pattern('go.mod', '.git')(fname)
    end,
  },
  docs = {
    description = [[
Combination of both lint server and client

https://github.com/nametake/golangci-lint-langserver
https://github.com/golangci/golangci-lint
]],
    default_config = {
      root_dir = [[root_pattern("go.mod", ".git")]],
    },
  },
}
