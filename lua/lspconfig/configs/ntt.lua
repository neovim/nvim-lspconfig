local bin_name = 'ntt'

return {
  default_config = {
    cmd = { bin_name, 'langserver' },
    filetypes = { 'ttcn' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ '.git' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/nokia/ntt
Installation instructions can be found [here](https://github.com/nokia/ntt#Install).
Can be configured by passing a "settings" object to `ntt.setup{}`:
```lua
require('lspconfig').ntt.setup{
    settings = {
      ntt = {
      }
    }
}
```
]],
  },
}
