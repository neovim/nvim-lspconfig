return {
  default_config = {
    cmd = { 'bsc', '--lsp', '--stdio' },
    filetypes = { 'brs' },
    single_file_support = true,
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'makefile', 'Makefile', '.git' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/RokuCommunity/brighterscript

`brightscript` can be installed via `npm`:
```sh
npm install -g brighterscript
```
]],
  },
}
