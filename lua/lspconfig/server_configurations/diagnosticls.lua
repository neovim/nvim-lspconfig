local util = require 'lspconfig.util'

local bin_name = 'diagnostic-languageserver'
local cmd = { bin_name, '--stdio' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, '--stdio' }
end

return {
  default_config = {
    cmd = cmd,
    root_dir = util.find_git_ancestor,
    single_file_support = true,
    filetypes = {},
  },
  docs = {
    -- Since diagnostic-languageserver is configured using initializationOptions, it is inappropriate to specify package_json.
    -- package_json = 'https://raw.githubusercontent.com/iamcco/coc-diagnostic/master/package.json',
    description = [[
https://github.com/iamcco/diagnostic-languageserver

Diagnostic language server integrate with linters.
]],
    default_config = {
      filetypes = 'Empty by default, override to add filetypes',
      root_dir = "Vim's starting directory",
      init_options = 'Configuration from https://github.com/iamcco/diagnostic-languageserver#config--document',
    },
  },
}
