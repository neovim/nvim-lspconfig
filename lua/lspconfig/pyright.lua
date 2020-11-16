local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = "pyright"

local function organize_imports(bufnr)
  bufnr = util.validate_bufnr(bufnr)
  local uri = vim.uri_from_bufnr(bufnr)
  local params = {
    command = 'pyright.organizeimports';
    arguments = { uri }
  }

  local edits = vim.lsp.buf_request(bufnr, 'workspace/executeCommand', params, function(err, _, _)
    if err then error(tostring(err)) end
end)

  if edits then
    vim.lsp.util.apply_workspace_edit(edits)
  end
end

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
   commands = {
      PyrightOrganizeImports = {
      function()
        organize_imports(0)
      end;
      description = "Organize Import Statements";
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
configs[server_name].organize_imports = organize_imports
-- vim:et ts=2 sw=2
