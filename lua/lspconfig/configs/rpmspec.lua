return {
  default_config = {
    cmd = { 'rpm_lsp_server', '--stdio' },
    filetypes = { 'spec' },
    single_file_support = true,
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    settings = {},
  },
  docs = {
    description = [[
https://github.com/dcermak/rpm-spec-language-server

Language server protocol (LSP) support for RPM Spec files.

`rpm-spec-language-server` can be installed by running,

```sh
pip install rpm-spec-language-server
```
]],
  },
}
