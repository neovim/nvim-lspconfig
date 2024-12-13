return {
  default_config = {
    cmd = { 'svls' },
    filetypes = { 'verilog', 'systemverilog' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/dalance/svls

Language server for verilog and SystemVerilog

`svls` can be installed via `cargo`:
 ```sh
 cargo install svls
 ```
    ]],
  },
}
