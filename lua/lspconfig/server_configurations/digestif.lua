local util = require 'lspconfig.util'

local bin_name = 'digestif'
local cmd = { bin_name }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name }
end

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'tex', 'plaintex', 'context' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/astoff/digestif

Digestif is a code analyzer, and a language server, for LaTeX, ConTeXt et caterva. It provides

context-sensitive completion, documentation, code navigation, and related functionality to any

text editor that speaks the LSP protocol.
]],
  },
}
