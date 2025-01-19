return {
  default_config = {
    cmd = { 'cue', 'lsp' },
    filetypes = { 'cue' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'cue.mod', '.git' }, { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/cue-lang/cue

CUE makes it easy to validate data, write schemas, and ensure configurations align with policies.
]],
  },
}
