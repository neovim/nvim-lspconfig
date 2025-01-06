local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'clojure-lsp' },
    filetypes = { 'clojure', 'edn' },
    root_dir = function(pattern)
      local fallback = vim.loop.cwd()
      local patterns = { 'project.clj', 'deps.edn', 'build.boot', 'shadow-cljs.edn', '.git', 'bb.edn' }
      local root = util.root_pattern(patterns)(pattern)

      return root or fallback
    end,
  },
  docs = {
    description = [[
https://github.com/clojure-lsp/clojure-lsp

Clojure Language Server
]],
  },
}
