local root_files = { 'configure.ac', 'Makefile', 'Makefile.am', '*.mk' }

return {
  default_config = {
    cmd = { 'autotools-language-server' },
    filetypes = { 'config', 'automake', 'make' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ unpack(root_files) }, { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/Freed-Wu/autotools-language-server

`autotools-language-server` can be installed via `pip`:
```sh
pip install autotools-language-server
```

Language server for autoconf, automake and make using tree sitter in python.
]],
  },
}
