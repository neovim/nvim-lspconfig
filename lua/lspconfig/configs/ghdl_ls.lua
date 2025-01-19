return {
  default_config = {
    cmd = { 'ghdl-ls' },
    filetypes = { 'vhdl' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'hdl-prj.json', '.git' }, { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/ghdl/ghdl-language-server

A language server for VHDL, using ghdl as its backend.

`ghdl-ls` is part of pyghdl, for installation instructions see
[the upstream README](https://github.com/ghdl/ghdl/tree/master/pyGHDL/lsp).
]],
  },
}
