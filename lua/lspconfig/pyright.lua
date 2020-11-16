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
    settings = {
      analysis = { autoSearchPaths= true; };
      pyright = { useLibraryCodeForTypes = true; };
    };
    -- The following before_init function can be removed once https://github.com/neovim/neovim/pull/12638 is merged
    before_init = function(initialize_params)
            initialize_params['workspaceFolders'] = {{
                name = 'workspace',
                uri = initialize_params['rootUri']
            }}
    end
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
