return {
  default_config = {
    cmd = { 'nxls', '--stdio' },
    filetypes = { 'json', 'jsonc' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'nx.json', '.git' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/nrwl/nx-console/tree/master/apps/nxls

nxls, a language server for Nx Workspaces

`nxls` can be installed via `npm`:
```sh
npm i -g nxls
```
]],
  },
}
