local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'tinymist' },
    filetypes = { 'typst' },
    root_dir = function(fname)
      if util.find_git_ancestor(fname) then
        return util.find_git_ancestor(fname)
      else
        return vim.fn.getcwd()
      end
    end,
    single_file_support = false,
  },
  docs = {
    description = [[
https://github.com/Myriad-Dreamin/tinymist
An integrated language service for Typst [taɪpst]. You can also call it "微霭" [wēi ǎi] in Chinese.
    ]],
  },
}
