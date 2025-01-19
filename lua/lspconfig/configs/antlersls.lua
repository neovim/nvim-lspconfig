return {
  default_config = {
    cmd = { 'antlersls', '--stdio' },
    filetypes = { 'html', 'antlers' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'composer.json' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://www.npmjs.com/package/antlers-language-server

`antlersls` can be installed via `npm`:
```sh
npm install -g antlers-language-server
```
]],
  },
}
