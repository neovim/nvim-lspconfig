-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- This config is DEPRECATED.
-- Use the configs in `lsp/` instead (requires Nvim 0.11).
--
-- ALL configs in `lua/lspconfig/configs/` will be DELETED.
-- They exist only to support Nvim 0.10 or older.
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
local util = require 'lspconfig.util'

local bin_name = 'theme-check-language-server'

return {
  default_config = {
    cmd = { bin_name, '--stdio' },
    filetypes = { 'liquid' },
    root_dir = util.root_pattern '.theme-check.yml',
    settings = {},
  },
  docs = {
    description = [[
https://github.com/Shopify/shopify-cli

`theme-check-language-server` is bundled with `shopify-cli` or it can also be installed via

https://github.com/Shopify/theme-check#installation

**NOTE:**
If installed via Homebrew, `cmd` must be set to 'theme-check-liquid-server'

```lua
require lspconfig.theme_check.setup {
  cmd = { 'theme-check-liquid-server' }
}
```

]],
  },
}
