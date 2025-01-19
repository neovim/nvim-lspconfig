return {
  default_config = {
    cmd = { 'earthlyls' },
    filetypes = { 'earthfile' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'Earthfile' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/glehmann/earthlyls

A fast language server for earthly.
]],
  },
}
