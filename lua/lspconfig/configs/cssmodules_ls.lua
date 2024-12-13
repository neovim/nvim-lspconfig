return {
  default_config = {
    cmd = { 'cssmodules-language-server' },
    filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('package.json', { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/antonk52/cssmodules-language-server

Language server for autocompletion and go-to-definition functionality for CSS modules.

You can install cssmodules-language-server via npm:
```sh
npm install -g cssmodules-language-server
```
    ]],
  },
}
