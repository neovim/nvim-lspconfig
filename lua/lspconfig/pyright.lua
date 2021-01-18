local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = "pyright"
local bin_name = "pyright-langserver"
if vim.fn.has('win32') == 1 then
  bin_name = bin_name..".cmd"
end

local root_files = {
  'setup.py',
  'pyproject.toml',
  'setup.cfg',
  'requirements.txt',
  '.git',
}

configs[server_name] = {
  default_config = {
    cmd = {bin_name, "--stdio"};
    filetypes = {"python"};
    root_dir = function(filename)
      return util.root_pattern(unpack(root_files))(filename) or
             util.path.dirname(filename)
    end;
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

-- vim:et ts=2 sw=2
