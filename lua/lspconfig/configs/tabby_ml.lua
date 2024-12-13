return {
  default_config = {
    cmd = { 'tabby-agent', '--lsp', '--stdio' },
    filetypes = {},
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://tabby.tabbyml.com/blog/running-tabby-as-a-language-server

Language server for Tabby, an opensource, self-hosted AI coding assistant.

`tabby-agent` can be installed via `npm`:

```sh
npm install --global tabby-agent
```
]],
  },
}
