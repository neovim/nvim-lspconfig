return {
  default_config = {
    cmd = { 'ember-language-server', '--stdio' },
    filetypes = { 'handlebars', 'typescript', 'javascript', 'typescript.glimmer', 'javascript.glimmer' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'ember-cli-build.js', '.git' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/ember-tooling/ember-language-server

`ember-language-server` can be installed via `npm`:

```sh
npm install -g @ember-tooling/ember-language-server
```
]],
  },
}
