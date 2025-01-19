return {
  default_config = {
    cmd = { 'npx', '--no-install', 'flow', 'lsp' },
    filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ '.flowconfig' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://flow.org/
https://github.com/facebook/flow

See below for how to setup Flow itself.
https://flow.org/en/docs/install/

See below for lsp command options.

```sh
npx flow lsp --help
```
    ]],
  },
}
