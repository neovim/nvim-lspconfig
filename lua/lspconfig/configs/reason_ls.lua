return {
  default_config = {
    cmd = { 'reason-language-server' },
    filetypes = { 'reason' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'bsconfig.json', '.git' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
Reason language server

You can install reason language server from [reason-language-server](https://github.com/jaredly/reason-language-server) repository.
]],
  },
}
