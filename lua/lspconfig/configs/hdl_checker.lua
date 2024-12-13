return {
  default_config = {
    cmd = { 'hdl_checker', '--lsp' },
    filetypes = { 'vhdl', 'verilog', 'systemverilog' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/suoto/hdl_checker
Language server for hdl-checker.
Install using: `pip install hdl-checker --upgrade`
]],
  },
}
