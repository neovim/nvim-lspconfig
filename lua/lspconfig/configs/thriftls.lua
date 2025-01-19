return {
  default_config = {
    cmd = { 'thriftls' },
    filetypes = { 'thrift' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ '.thrift' }, { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/joyme123/thrift-ls

you can install thriftls by mason or download binary here: https://github.com/joyme123/thrift-ls/releases
]],
  },
}
