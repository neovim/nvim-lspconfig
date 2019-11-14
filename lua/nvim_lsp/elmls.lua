local skeleton = require 'nvim_lsp/skeleton'
local util = require 'nvim_lsp/util'
local lsp = vim.lsp

local default_capabilities = lsp.protocol.make_client_capabilities()
default_capabilities.offsetEncoding = {"utf-8", "utf-16"}

skeleton.elmls = {
  default_config = {
    cmd = {"elm-language-server"};
    filetypes = {"elm"};
    root_dir = util.root_pattern("elm.json");
    log_level = lsp.protocol.MessageType.Warning;
    settings = {};
    init_options = {
      elmPath = "elm",
      elmFormatPath = "elm-format",
      elmTestPath = "elm-test",
      elmAnalyseTrigger = "change",
    };
    capabilities = default_capabilities;
    on_init = function(client, result)
      if result.offsetEncoding then
        client.offset_encoding = result.offsetEncoding
      end
    end
  };
  docs = {
    description = [[
https://github.com/elm-tooling/elm-language-server#installation

elm-language-server (elmLS) relies on having a few dependencies installed:
```sh
npm install -g elm elm-test elm-format @elm-tooling/elm-language-server
```
]];
    default_config = {
      root_dir = [[root_pattern("elm.json")]];
      on_init = [[function to handle changing offsetEncoding]];
      capabilities = [[default capabilities, with offsetEncoding utf-8]];
    };
  };
}
-- vim:et ts=2 sw=2
