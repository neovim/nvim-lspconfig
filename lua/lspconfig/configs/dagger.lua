return {
  default_config = {
    cmd = { 'cuelsp' },
    filetypes = { 'cue' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'cue.mod', '.git' }, { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/dagger/cuelsp

Dagger's lsp server for cuelang.
]],
  },
}
