local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.unified_language_server_md = {
  default_config = {
    cmd = { "unified-language-server", "--parser=remark-parse", "--stdio" },
    filetypes = {"markdown"},
    root_dir = util.path.dirname,
  },
  docs = {
    description = [[
[Unified language server](https://github.com/unifiedjs/unified-language-server) designed by UnifiedJS

Can be installed via npm or yarn
```bash
npm install -g unified-language-server  # npm
yarn global add unified-language-server # yarn
```
]];
    default_config = {
      root_dir = "util.path.dirname";
    }
  }
}

