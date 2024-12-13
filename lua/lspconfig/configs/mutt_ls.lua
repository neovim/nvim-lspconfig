return {
  default_config = {
    cmd = { 'mutt-language-server' },
    filetypes = { 'muttrc', 'neomuttrc' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
    settings = {},
  },
  docs = {
    description = [[
https://github.com/neomutt/mutt-language-server

A language server for (neo)mutt's muttrc. It can be installed via pip.

```sh
pip install mutt-language-server
```
  ]],
  },
}
