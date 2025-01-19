return {
  default_config = {
    cmd = { 'sql-language-server', 'up', '--method', 'stdio' },
    filetypes = { 'sql', 'mysql' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ '.sqllsrc.json' }, { path = fname, upward = true })[1])
    end,
    settings = {},
  },
  docs = {
    description = [[
https://github.com/joe-re/sql-language-server

This LSP can be installed via  `npm`. Find further instructions on manual installation of the sql-language-server at [joe-re/sql-language-server](https://github.com/joe-re/sql-language-server).
<br>
    ]],
  },
}
