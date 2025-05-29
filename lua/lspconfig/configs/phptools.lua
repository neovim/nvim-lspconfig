local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'devsense-php-ls', '--stdio' },
    filetypes = { 'php' },
    root_dir = function(pattern)
      local cwd = vim.uv.cwd()
      local root = util.root_pattern('composer.json', '.git')(pattern)

      -- prefer cwd if root is a descendant
      return util.path.is_descendant(cwd, root) and cwd or root
    end,
  },
  docs = {
    description = [[
https://www.devsense.com/

`devsense-php-ls` can be installed via `npm`:
```sh
npm install -g devsense-php-ls
```

```lua
-- See https://www.npmjs.com/package/devsense-php-ls
init_options = {
}
-- See https://docs.devsense.com/vscode/configuration/
settings = {
  php = {
  };
}
```
]],
  },
}
