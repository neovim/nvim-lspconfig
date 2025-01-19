return {
  default_config = {
    cmd = { 'vscoqtop' },
    filetypes = { 'coq' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ '_CoqProject', '.git' }, { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/coq-community/vscoq
]],
  },
}
