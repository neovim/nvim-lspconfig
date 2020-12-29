local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = "tsserver"
local bin_name = "typescript-language-server"
if vim.fn.has('win32') == 1 then
  bin_name = bin_name..".cmd"
end

local installer = util.npm_installer {
  server_name = server_name;
  packages = { "typescript-language-server" };
  binaries = {bin_name};
}

configs[server_name] = {
  default_config = {
    cmd = {bin_name, "--stdio"};
    filetypes = {"javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx"};
    root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git");
  };
  on_new_config = function(new_config)
    local install_info = installer.info()
    if install_info.is_installed then
      if type(new_config.cmd) == 'table' then
        -- Try to preserve any additional args from upstream changes.
        new_config.cmd[1] = install_info.binaries[bin_name]
      else
        new_config.cmd = {install_info.binaries[bin_name]}
      end
    end
  end;
  docs = {
    description = [[
https://github.com/theia-ide/typescript-language-server

`typescript-language-server` can be installed via `:LspInstall tsserver` or by yourself with `npm`:
```sh
npm install -g typescript-language-server
```
]];
    default_config = {
      root_dir = [[root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git")]];
    };
  };
}

configs[server_name].install = installer.install
configs[server_name].install_info = installer.info
-- vim:et ts=2 sw=2
