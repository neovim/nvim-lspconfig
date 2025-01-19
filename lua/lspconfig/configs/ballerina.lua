return {
  default_config = {
    cmd = { 'bal', 'start-language-server' },
    filetypes = { 'ballerina' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'Ballerina.toml' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
Ballerina language server

The Ballerina language's CLI tool comes with its own language server implementation.
The `bal` command line tool must be installed and available in your system's PATH.
]],
  },
}
