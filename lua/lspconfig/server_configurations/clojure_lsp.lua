local util = require 'lspconfig.util'

local workspace_markers = { 'project.clj', 'deps.edn', 'build.boot', 'shadow-cljs.edn', '.git' }

return {
  default_config = {
    cmd = { 'clojure-lsp' },
    filetypes = { 'clojure', 'edn' },
    root_dir = util.root_pattern(unpack(workspace_markers)),
  },
  docs = {
    description = [[
https://github.com/clojure-lsp/clojure-lsp

Clojure Language Server
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
