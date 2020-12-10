local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.nimls = {
  default_config = {
    cmd = {"nimlsp",};
    filetypes = {'nim'};
    root_dir = function(fname)
      return util.find_git_ancestor(fname) or vim.loop.os_homedir()
    end;
  };
  docs = {
    package_json = "https://raw.githubusercontent.com/pragmagic/vscode-nim/master/package.json";
    description = [[
https://github.com/PMunch/nimlsp
`nimlsp` can be installed via `:LspInstall nimls` or by yourself the `nimble` package manager:
```sh
nimble install nimlsp
```
    ]];
    default_config = {
      root_dir = [[root_pattern(".git") or os_homedir]];
    };
  };
}

configs.nimls.install = function()
  local script = [[
  nimble install nimlsp
  ]]

  util.sh(script, vim.loop.os_homedir())
end

configs.nimls.install_info = function()
  local script = [[
  nimlsp --version
  ]]

  local status = pcall(vim.fn.system, script)

  return {
    is_installed = status and vim.v.shell_error == 0;
  }
end
