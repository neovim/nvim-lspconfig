return {
  default_config = {
    cmd = { 'veryl-ls' },
    filetypes = { 'veryl' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/veryl-lang/veryl

Language server for Veryl

`veryl-ls` can be installed via `cargo`:
 ```sh
 cargo install veryl-ls
 ```
    ]],
  },
}
