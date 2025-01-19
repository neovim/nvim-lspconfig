return {
  default_config = {
    cmd = {
      'fortls',
      '--notify_init',
      '--hover_signature',
      '--hover_language=fortran',
      '--use_signature_help',
    },
    filetypes = { 'fortran' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ '.fortls', '.git' }, { path = fname, upward = true })[1])
    end,
    settings = {},
  },
  docs = {
    description = [[
https://fortls.fortran-lang.org/index.html

fortls is a Fortran Language Server, the server can be installed via pip

```sh
pip install fortls
```

Settings to the server can be passed either through the `cmd` option or through
a local configuration file e.g. `.fortls`. For more information
see the `fortls` [documentation](https://fortls.fortran-lang.org/options.html).
    ]],
  },
}
