local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'typst-lsp' },
    filetypes = { 'typst' },
    root_dir = function(fname)
      root_dir = function(fname)
        if util.find_git_ancestor(fname) then
          return util.find_git_ancestor(fname)
        else return vim.fn.getcwd()
        end
      end,
    end,
  },
  docs = {
    description = [[
https://github.com/nvarner/typst-lsp

Language server for Typst.
    ]],
  },
}
