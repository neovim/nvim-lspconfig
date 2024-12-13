return {
  default_config = {
    cmd = { 'salt_lsp_server' },
    filetypes = { 'sls' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
Language server for Salt configuration files.
https://github.com/dcermak/salt-lsp

The language server can be installed with `pip`:
```sh
pip install salt-lsp
```
    ]],
  },
}
