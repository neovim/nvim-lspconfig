return {
  default_config = {
    cmd = { 'v', 'ls' },
    filetypes = { 'v', 'vlang' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'v.mod', '.git' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/vlang/vls

V language server.

`v-language-server` can be installed by following the instructions [here](https://github.com/vlang/vls#installation).
]],
  },
}
