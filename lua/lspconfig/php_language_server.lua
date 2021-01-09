local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = "php_language_server"

configs[server_name] = {
  default_config = {
    filetypes = {"php"};
    root_dir = function (pattern)
      local cwd  = vim.loop.cwd();
      local root = util.root_pattern("composer.json", ".git")(pattern);

      -- prefer cwd if root is a descendant
      return util.path.is_descendant(cwd, root) and cwd or root;
    end;
  };
  docs = {
    description = [[
https://github.com/felixfbecker/php-language-server

PHP Implementation of the VS Code Language Server Protocol

`php-language-server` can be installed via `composer`:
```sh
# To install the language server
composer require felixfbecker/language-server
# To parse stubs
composer run-script --working-dir=vendor/felixfbecker/language-server parse-stubs
```

To use `php-language-server`, you must define `cmd` when you setup the language server:
```lua
require'lspconfig'.php_language_server.setup {
  cmd = {"php", "vendor/felixfbecker/language-server/bin/php-language-server.php"};
};
```

]];
    default_config = {
      root_dir = [[root_pattern("composer.json", ".git")]];
    };
  };
}

-- vim:et ts=2 sw=2

