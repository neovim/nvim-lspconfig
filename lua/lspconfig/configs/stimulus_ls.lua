return {
  default_config = {
    cmd = { 'stimulus-language-server', '--stdio' },
    filetypes = { 'html', 'ruby', 'eruby', 'blade', 'php' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'Gemfile', '.git' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://www.npmjs.com/package/stimulus-language-server

`stimulus-lsp` can be installed via `npm`:

```sh
npm install -g stimulus-language-server
```

or via `yarn`:

```sh
yarn global add stimulus-language-server
```
]],
  },
}
