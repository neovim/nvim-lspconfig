local root = vim.fn.getcwd()

describe('ruby_lsp', function()
  --- @diagnostic disable-next-line:undefined-field
  local truthy = assert.is_true
  --- @diagnostic disable-next-line:undefined-field
  local falsy = assert.is_false

  before_each(function()
    vim.api.nvim_command('cd ' .. root)
  end)

  local cfg = dofile(root .. '/lsp/ruby_lsp.lua')

  describe('reuse_client', function()
    -- Pins the dedup contract: nothing in `cmd` or `reuse_client` sets
    -- `cmd_cwd` on the existing client, so dedup must compare a field
    -- that is actually persisted (`root_dir`). Otherwise every second
    -- `vim.lsp.start` for the same project spawns a duplicate client.
    it('reuses a client started for the same root_dir', function()
      local client = { name = 'ruby_lsp', config = { root_dir = '/foo' } }
      local config = { name = 'ruby_lsp', root_dir = '/foo' }
      truthy(cfg.reuse_client(client, config))
    end)

    it('does not reuse a client with a different root_dir', function()
      local client = { name = 'ruby_lsp', config = { root_dir = '/foo' } }
      local config = { name = 'ruby_lsp', root_dir = '/bar' }
      falsy(cfg.reuse_client(client, config))
    end)

    it('does not reuse a client with a different name', function()
      local client = { name = 'other_ls', config = { root_dir = '/foo' } }
      local config = { name = 'ruby_lsp', root_dir = '/foo' }
      falsy(cfg.reuse_client(client, config))
    end)
  end)
end)
