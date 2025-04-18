---@brief
---
--- https://github.com/iamcco/vim-language-server
---
--- You can install vim-language-server via npm:
--- ```sh
--- npm install -g vim-language-server
--- ```
return {
  cmd = { 'vim-language-server', '--stdio' },
  filetypes = { 'vim' },
  root_markers = { '.git' },
  init_options = {
    isNeovim = true,
    iskeyword = '@,48-57,_,192-255,-#',
    vimruntime = '',
    runtimepath = '',
    diagnostic = { enable = true },
    indexes = {
      runtimepath = true,
      gap = 100,
      count = 3,
      projectRootPatterns = { 'runtime', 'nvim', '.git', 'autoload', 'plugin' },
    },
    suggest = { fromVimruntime = true, fromRuntimepath = true },
  },
}
