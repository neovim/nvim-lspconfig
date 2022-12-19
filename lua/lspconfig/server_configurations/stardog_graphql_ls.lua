local util = require 'lspconfig.util'

local bin_name = 'stardog-graphql-language-server'
local full_path = util.find_bin_path(bin_name)
local cmd = { 'node', full_path, '--stdio' }

return {
  default_config = {
    cmd = util.adapt_command_windows(cmd),
    filetypes = { 'graphql', 'gql' },
    root_dir = function(fname)
      return util.find_git_ancestor(fname)
    end,
  },
  docs = {
    description = [[
https://github.com/stardog-union/stardog-language-servers/tree/master/packages/stardog-graphql-language-server
A server providing language intelligence (autocomplete, diagnostics, hover tooltips, etc.) for GraphQL, including both standard GraphQL and Stardog extensions, via the Language Server Protocol.
installable via npm install -g stardog-graphql-language-server or yarn global add stardog-graphql-language-server.
requires node.
]],
  },
}
