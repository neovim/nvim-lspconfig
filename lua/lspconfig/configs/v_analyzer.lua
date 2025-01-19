return {
  default_config = {
    cmd = { 'v-analyzer' },
    filetypes = { 'v', 'vsh', 'vv' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'v.mod', '.git' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/vlang/v-analyzer

V language server.

`v-analyzer` can be installed by following the instructions [here](https://github.com/vlang/v-analyzer#installation).
]],
  },
}
