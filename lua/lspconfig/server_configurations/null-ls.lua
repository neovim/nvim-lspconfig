local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'nvim' },
    autostart = false,
    root_dir = function(fname)
      return util.root_pattern('.null-ls-root', 'Makefile', '.git')(fname)
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/jose-elias-alvarez/null-ls.nvim

Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua.
]],
    default_config = {
      root_dir = [[util.find_git_ancestor]],
    },
  },
}
