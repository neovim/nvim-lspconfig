local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = "pyright"

local installer = util.npm_installer {
  server_name = server_name;
  packages = {server_name};
  binaries = {server_name};
}

configs[server_name] = {
  default_config = {
    cmd = {"pyright-langserver", "--stdio"};
    filetypes = {"python"};
    root_dir = util.root_pattern(".git", "setup.py",  "setup.cfg", "pyproject.toml", "requirements.txt");
    handlers = {
      -- pyright ignores dynamicRegistration settings
      ['client/registerCapability'] = function(_, _, _, _)
        return {
          result = nil;
          error = nil;
        }
      end
    };
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true;
          useLibraryCodeForTypes = true;
        };
      };
    };
   };
  docs = {
    description = [[
https://github.com/microsoft/pyright

`pyright`, a static type checker and language server for python
]];
  };
}

configs[server_name].install = installer.install
configs[server_name].install_info = installer.info
-- vim:et ts=2 sw=2
