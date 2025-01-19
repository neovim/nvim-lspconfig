return {
  default_config = {
    cmd = { 'templ', 'lsp' },
    filetypes = { 'templ' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'go.work', 'go.mod', '.git' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://templ.guide

The official language server for the templ HTML templating language.
]],
  },
}
