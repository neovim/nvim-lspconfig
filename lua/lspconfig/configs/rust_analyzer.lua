local util = require 'lspconfig.util'
local async = require 'lspconfig.async'

local function reload_workspace(bufnr)
  bufnr = util.validate_bufnr(bufnr)
  local clients = vim.lsp.get_clients { bufnr = bufnr, name = 'rust_analyzer' }
  for _, client in ipairs(clients) do
    vim.notify 'Reloading Cargo Workspace'
    client.request('rust-analyzer/reloadWorkspace', nil, function(err)
      if err then
        error(tostring(err))
      end
      vim.notify 'Cargo workspace reloaded'
    end, 0)
  end
end

local function is_library(fname)
  local user_home = vim.fs.normalize(vim.env.HOME)
  local cargo_home = os.getenv 'CARGO_HOME' or user_home .. '/.cargo'
  local registry = cargo_home .. '/registry/src'
  local git_registry = cargo_home .. '/git/checkouts'

  local rustup_home = os.getenv 'RUSTUP_HOME' or user_home .. '/.rustup'
  local toolchains = rustup_home .. '/toolchains'

  for _, item in ipairs { toolchains, registry, git_registry } do
    if util.path.is_descendant(item, fname) then
      local clients = vim.lsp.get_clients { name = 'rust_analyzer' }
      return #clients > 0 and clients[#clients].config.root_dir or nil
    end
  end
end

return {
  default_config = {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    single_file_support = true,
    root_dir = function(fname)
      local reuse_active = is_library(fname)
      if reuse_active then
        return reuse_active
      end

      local cargo_crate_dir = util.root_pattern 'Cargo.toml'(fname)
      local cargo_workspace_root

      if cargo_crate_dir ~= nil then
        local cmd = {
          'cargo',
          'metadata',
          '--no-deps',
          '--format-version',
          '1',
          '--manifest-path',
          cargo_crate_dir .. '/Cargo.toml',
        }

        local result = async.run_command(cmd)

        if result and result[1] then
          result = vim.json.decode(table.concat(result, ''))
          if result['workspace_root'] then
            cargo_workspace_root = vim.fs.normalize(result['workspace_root'])
          end
        end
      end

      return cargo_workspace_root
        or cargo_crate_dir
        or util.root_pattern 'rust-project.json'(fname)
        or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    capabilities = {
      experimental = {
        serverStatusNotification = true,
      },
    },
    before_init = function(init_params, config)
      -- See https://github.com/rust-lang/rust-analyzer/blob/eb5da56d839ae0a9e9f50774fa3eb78eb0964550/docs/dev/lsp-extensions.md?plain=1#L26
      if config.settings and config.settings['rust-analyzer'] then
        init_params.initializationOptions = config.settings['rust-analyzer']
      end
    end,
  },
  commands = {
    CargoReload = {
      function()
        reload_workspace(0)
      end,
      description = 'Reload current cargo workspace',
    },
  },
  docs = {
    description = [[
https://github.com/rust-lang/rust-analyzer

rust-analyzer (aka rls 2.0), a language server for Rust


See [docs](https://rust-analyzer.github.io/book/configuration.html) for extra settings. The settings can be used like this:
```lua
require'lspconfig'.rust_analyzer.setup{
  settings = {
    ['rust-analyzer'] = {
      diagnostics = {
        enable = false;
      }
    }
  }
}
```

Note: do not set `init_options` for this LS config, it will be automatically populated by the contents of settings["rust-analyzer"] per
https://github.com/rust-lang/rust-analyzer/blob/eb5da56d839ae0a9e9f50774fa3eb78eb0964550/docs/dev/lsp-extensions.md?plain=1#L26.
    ]],
  },
}
