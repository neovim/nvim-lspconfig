local util = require 'lspconfig.util'

local bin_name = 'donat'
local dll_path = '/opt/dafny/DafnyLanguageServer.dll'
local cmd = {bin_name, dll_path}
if vim.fn.has 'win32' == 1 then
  dll_path = 'C:\\Program Files\\dafny\\DafnyLanguageServer.dll'
  cmd = { 'cmd.exe', '/C', bin_name, dll_path }
end

return {
  default_config = {
    filetypes = { 'dfy', 'dafny' },
    cmd = cmd,
    root_dir = function(fname)
      util.find_git_ancestor(fname)
    end,
    single_file_support = true
  },
  docs = {
    description = [[
    Lsp for dafny
]],
  },
}
