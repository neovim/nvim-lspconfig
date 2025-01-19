return {
  default_config = {
    cmd = { 'snakeskin-cli', 'lsp', '--stdio' },
    filetypes = { 'ss' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'package.json' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://www.npmjs.com/package/@snakeskin/cli

`snakeskin cli` can be installed via `npm`:
```sh
npm install -g @snakeskin/cli
```
]],
  },
}
