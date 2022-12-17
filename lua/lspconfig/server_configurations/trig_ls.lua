local util = require 'lspconfig.util'

local bin_name = 'trig-language-server'
local full_path = util.find_bin_path(bin_name)

local cmd = { 'node', full_path, '--stdio' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', 'node', full_path, '--stdio' }
end

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'trig' },
    root_dir = function(fname)
      return util.find_git_ancestor(fname)
    end,
  },
  docs = {
    description = [[
https://github.com/stardog-union/stardog-language-servers/tree/master/packages/trig-language-server
An editor-agnostic server providing language intelligence (diagnostics, hover tooltips, etc.) for the W3C standard TriG RDF syntax via the Language Server Protocol.
installable via npm install -g trig-language-server or yarn global add trig-language-server.
requires node.
]],
  },
}
