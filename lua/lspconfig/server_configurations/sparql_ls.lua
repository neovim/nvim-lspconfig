local util = require 'lspconfig.util'

local bin_name = 'sparql-language-server'
local full_path = util.find_bin_path(bin_name)
local cmd = { 'node', full_path, '--stdio' }

return {
  default_config = {
    cmd = util.adapt_command_windows(cmd),
    filetypes = { 'sparql', 'rq' },
    root_dir = function(fname)
      return util.find_git_ancestor(fname)
    end,
  },
  docs = {
    description = [[
https://github.com/stardog-union/stardog-language-servers/tree/master/packages/sparql-language-server
A server providing language intelligence (autocomplete, diagnostics, hover tooltips, etc.) for the SPARQL query language, including both W3C standard SPARQL and Stardog extensions (e.g., PATHS queries), via the Language Server Protocol.
installable via npm install -g sparql-language-server or yarn global add sparql-language-server.
requires node.
]],
  },
}
