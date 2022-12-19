local util = require 'lspconfig.util'

local bin_name = 'shacl-language-server'
local full_path = util.find_bin_path(bin_name)
local cmd = { "node", full_path, '--stdio' }

return {
  default_config = {
    cmd = util.adapt_command_windows(cmd),
    filetypes = { 'turtle', 'ttl' },
    root_dir = function(fname)
      return util.find_git_ancestor(fname)
    end,
  },
  docs = {
    description = [[
https://github.com/stardog-union/stardog-language-servers/tree/master/packages/shacl-language-server
A server providing language intelligence (diagnostics, hover tooltips, completions, etc.) for the Turtle serialization of the W3C Shapes Constraint Language (SHACL) via the Language Server Protocol.
Installable via npm install -g shacl-language-server or yarn global add shacl-language-server.
Requires node.
]],
  },
}
