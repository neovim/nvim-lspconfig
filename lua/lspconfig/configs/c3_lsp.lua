return {
  default_config = {
    cmd = { 'c3lsp' },
    root_dir = function(fname)
      return vim.fs.dirname(
        vim.fs.find({ 'project.json', 'manifest.json', '.git' }, { path = fname, upward = true })[1]
      )
    end,
    filetypes = { 'c3', 'c3i' },
  },
  docs = {
    description = [[
https://github.com/pherrymason/c3-lsp

Language Server for c3.
]],
  },
}
