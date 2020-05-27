local configs = require 'nvim_lsp/configs'
local util = require 'nvim_lsp/util'

local server_name = "javascript_typescript_langserver"
local bin_name = "javascript-typescript-stdio"

local installer = util.npm_installer {
  server_name = server_name;
  packages = { "javascript-typescript-langserver" };
  binaries = {bin_name};
}

configs[server_name] = {
  default_config = {
    cmd = { bin_name };
    filetypes = {"javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx"};
    root_dir = util.root_pattern("package.json", "tsconfig.json", ".git");
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
https://github.com/sourcegraph/javascript-typescript-langserver

`javascript-typescript-langserver` can be installed via `:LspInstall javascript-typescript-langserver` or by yourself with `npm`:
```sh
npm install -g javascript-typescript-langserver
```
]];
    default_config = {
      root_dir = [[root_pattern("package.json", "tsconfig.json", ".git")]];
    };
  };
}

configs[server_name].install = installer.install
configs[server_name].install_info = installer.info
-- vim:et ts=2 sw=2
