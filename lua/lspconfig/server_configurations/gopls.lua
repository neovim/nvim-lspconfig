local util = require 'lspconfig.util'

local mod_cache = nil

return {
  default_config = {
    cmd = { 'gopls' },
    filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
    root_dir = function(fname)
      if mod_cache == nil then
        mod_cache = vim.trim(vim.fn.system 'go env GOMODCACHE')
      end
      -- see: https://github.com/neovim/nvim-lspconfig/issues/804
      if fname:sub(1, #mod_cache) == mod_cache then
        local clients = vim.lsp.get_active_clients { name = 'gopls' }
        if #clients > 0 then
          return clients[#clients].config.root_dir
        end
      end
      return util.root_pattern('go.work', 'go.mod', '.git')(fname)
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/golang/tools/tree/master/gopls

Google's lsp server for golang.
]],
    default_config = {
      root_dir = [[root_pattern("go.work", "go.mod", ".git")]],
    },
  },
}
