local util = require 'lspconfig.util'

local bin_name = 'standardrb'
local cmd = { bin_name, '--lsp' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, '--lsp' }
end

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'ruby' },
    root_dir = util.root_pattern('Gemfile', '.git'),
  },
  docs = {
    description = [[
https://github.com/testdouble/standard

Ruby Style Guide, with linter & automatic code fixer.
    ]],
    default_config = {
      root_dir = [[root_pattern("Gemfile", ".git")]],
    },
  },
}
