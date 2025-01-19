return {
  default_config = {
    cmd = { 'solargraph', 'stdio' },
    settings = {
      solargraph = {
        diagnostics = true,
      },
    },
    init_options = { formatting = true },
    filetypes = { 'ruby' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'Gemfile', '.git' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://solargraph.org/

solargraph, a language server for Ruby

You can install solargraph via gem install.

```sh
gem install --user-install solargraph
```
    ]],
  },
}
