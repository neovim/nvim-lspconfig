---@brief
---
--- https://github.com/termux/termux-language-server
---
--- Language server for various bash scripts such as Arch PKGBUILD, Gentoo ebuild, Termux build.sh, etc.

local util = require('lspconfig').util

---@type vim.lsp.Config
return {
  cmd = { 'termux-language-server' },
  root_dir = function(bufnr, on_dir)
    local patterns = {
      -- Termux
      'build.sh',
      '*.subpackage.sh',
      -- Arch/MSYS2
      'PKGBUILD',
      'makepkg.conf',
      '*.install',
      -- Gentoo
      'make.conf',
      'color.map',
      '*.ebuild',
      '*.eclass',
    }
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local match = util.root_pattern(patterns)(fname)
    on_dir(match and (vim.fs.root(match, '.git') or match))
  end,
}
