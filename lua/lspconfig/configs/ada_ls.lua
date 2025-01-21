return {
  default_config = {
    cmd = { 'ada_language_server' },
    filetypes = { 'ada' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'Makefile', '.git', '*.gpr', '*.adc' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/AdaCore/ada_language_server

Installation instructions can be found [here](https://github.com/AdaCore/ada_language_server#Install).

Can be configured by passing a "settings" object to `ada_ls.setup{}`:

```lua
require('lspconfig').ada_ls.setup{
    settings = {
      ada = {
        projectFile = "project.gpr";
        scenarioVariables = { ... };
      }
    }
}
```
]],
  },
}
