return {
  default_config = {
    cmd = {
      'janet-lsp',
      '--stdio',
    },
    filetypes = { 'janet' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'project.janet', '.git' }, { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/CFiggers/janet-lsp

A Language Server Protocol implementation for Janet.
]],
  },
}
