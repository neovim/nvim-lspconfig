return {
  default_config = {
    cmd = { 'verible-verilog-ls' },
    filetypes = { 'systemverilog', 'verilog' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/chipsalliance/verible

A linter and formatter for verilog and SystemVerilog files.

Release binaries can be downloaded from [here](https://github.com/chipsalliance/verible/releases)
and placed in a directory on PATH.

See https://github.com/chipsalliance/verible/tree/master/verilog/tools/ls/README.md for options.
    ]],
  },
}
