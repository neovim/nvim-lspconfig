local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = "vimls"
local bin_name = "vim-language-server"
if vim.fn.has('win32') == 1 then
  bin_name = bin_name..".cmd"
end

local installer = util.npm_installer {
  server_name = server_name,
  packages = {"vim-language-server"},
  binaries = {bin_name}
}

configs[server_name] = {
  default_config = {
    cmd = {bin_name, "--stdio"},
    filetypes = {"vim"},
    root_dir = function(fname)
      return util.find_git_ancestor(fname) or vim.loop.os_homedir()
    end,
    init_options = {
      iskeyword = "@,48-57,_,192-255,-#",
      vimruntime = "",
      runtimepath = "",
      diagnostic = {enable = true},
      indexes = {
        runtimepath = true,
        gap = 100,
        count = 3,
        projectRootPatterns = {"runtime", "nvim", ".git", "autoload", "plugin"}
      },
      suggest = {fromVimruntime = true, fromRuntimepath = true}
    },
    on_new_config = function(new_config)
      local install_info = installer.info()
      if install_info.is_installed then
        if type(new_config.cmd) == "table" then
          -- Try to preserve any additional args from upstream changes.
          new_config.cmd[1] = install_info.binaries[bin_name]
        else
          new_config.cmd = {install_info.binaries[bin_name]}
        end
      end
    end,
    docs = {
      description = [[
https://github.com/iamcco/vim-language-server

If you don't want to use Nvim to install it, then you can use:
```sh
npm install -g vim-language-server
```
]]
    }
  }
}

configs[server_name].install = installer.install
configs[server_name].install_info = installer.info

-- vim:et ts=2 sw=2
