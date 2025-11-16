-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- This config is DEPRECATED.
-- Use the configs in `lsp/` instead (requires Nvim 0.11).
--
-- ALL configs in `lua/lspconfig/configs/` will be DELETED.
-- They exist only to support Nvim 0.10 or older.
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
return {
  default_config = {
    cmd = { 'turbo-language-server', '--stdio' },
    filetypes = { 'html', 'ruby', 'eruby', 'blade', 'php' },
    root_dir = vim.fs.root(0, { 'Gemfile', '.git' }),
  },
  docs = {
    description = [[
https://www.npmjs.com/package/turbo-language-server

`turbo-language-server` can be installed via `npm`:

```sh
npm install -g turbo-language-server
```

or via `yarn`:

```sh
yarn global add turbo-language-server
```
]],
  },
}
