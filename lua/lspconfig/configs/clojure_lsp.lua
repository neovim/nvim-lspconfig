return {
  default_config = {
    cmd = { 'clojure-lsp' },
    filetypes = { 'clojure', 'edn' },
    root_dir = function(fname)
      return vim.fs.dirname(
        vim.fs.find(
          { 'project.clj', 'deps.edn', 'build.boot', 'shadow-cljs.edn', '.git', 'bb.edn' },
          { path = fname, upward = true }
        )[1]
      )
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/clojure-lsp/clojure-lsp

Clojure Language Server
]],
  },
}
