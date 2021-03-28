local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = "yamlls"

local bin_name
if vim.fn.has("win32") == 1 then
  bin_name = "yaml-language-server.cmd"
else
  bin_name = "yaml-language-server"
end

configs[server_name] = {
  default_config = {
    cmd = {bin_name, "--stdio"};
    filetypes = {"yaml"};
    root_dir = util.root_pattern(".git", vim.fn.getcwd());
  };
  docs = {
    package_json = "https://raw.githubusercontent.com/redhat-developer/vscode-yaml/master/package.json";
    description = [[
https://github.com/redhat-developer/yaml-language-server

`yaml-language-server` can be installed via `npm`:
```sh
npm install -g yaml-language-server
```
]];
    default_config = {
      root_dir = [[root_pattern(".git", vim.fn.getcwd())]];
    };
  };
}

-- vim:et ts=2 sw=2
