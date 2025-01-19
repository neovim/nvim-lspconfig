return {
  default_config = {
    cmd = { 'srb', 'tc', '--lsp' },
    filetypes = { 'ruby' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'Gemfile', '.git' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://sorbet.org

Sorbet is a fast, powerful type checker designed for Ruby.

You can install Sorbet via gem install. You might also be interested in how to set
Sorbet up for new projects: https://sorbet.org/docs/adopting.

```sh
gem install sorbet
```
    ]],
  },
}
