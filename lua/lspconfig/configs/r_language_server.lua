return {
  default_config = {
    cmd = { 'R', '--no-echo', '-e', 'languageserver::run()' },
    filetypes = { 'r', 'rmd', 'quarto' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1]) or vim.uv.os_homedir()
    end,
    log_level = vim.lsp.protocol.MessageType.Warning,
  },
  docs = {
    description = [[
[languageserver](https://github.com/REditorSupport/languageserver) is an
implementation of the Microsoft's Language Server Protocol for the R
language.

It is released on CRAN and can be easily installed by

```r
install.packages("languageserver")
```
]],
  },
}
