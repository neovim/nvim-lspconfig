return {
  default_config = {
    cmd = { 'dcm', 'start-server', '--client=neovim' },
    filetypes = { 'dart' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'pubspec.yaml' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://dcm.dev/

Language server for DCM analyzer.
]],
  },
}
