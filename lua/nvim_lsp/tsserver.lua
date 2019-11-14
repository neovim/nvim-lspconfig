local skeleton = require 'nvim_lsp/skeleton'
local util = require 'nvim_lsp/util'
local lsp = vim.lsp

local default_capabilities = lsp.protocol.make_client_capabilities()
default_capabilities.offsetEncoding = {"utf-8", "utf-16"}

skeleton.tsserver = {
  default_config = {
    cmd = {"typescript-language-server", "--stdio"};
    filetypes = {"typescript", "typescriptreact", "typescript.tsx"};
    root_dir = util.root_pattern("package.json");
    log_level = lsp.protocol.MessageType.Warning;
    settings = {};
    capabilities = default_capabilities;
    on_init = vim.schedule_wrap(function(client, result)
      if result.offsetEncoding then
        client.offset_encoding = result.offsetEncoding
      end
    end)
  };
  docs = {
    description = [[
https://github.com/theia-ide/typescript-language-server

typescript-language-server relies on having a few dependencies installed:
```sh
npm install -g typescript-language-server
```
]];
    default_config = {
      root_dir = [[root_pattern("package.json")]];
      on_init = [[function to handle changing offsetEncoding]];
      capabilities = [[default capabilities, with offsetEncoding utf-8]];
    };
  };
}
-- vim:et ts=2 sw=2
