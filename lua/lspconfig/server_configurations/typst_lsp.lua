local util = require 'lspconfig.util'

local cmd = { 'typst-lsp' }
if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', 'typst-lsp' }
end

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'typst' },
    root_dir = function(fname)
      return util.find_git_ancestor(fname)
    end,
  },
  docs = {
    description = [[
https://github.com/nvarner/typst-lsp

Language server for Typst.
    ]],
  },
}
