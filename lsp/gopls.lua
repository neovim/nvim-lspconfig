local util = require 'lspconfig.util'
local async = require 'lspconfig.async'
local mod_cache = nil

---@param fname string
---@return string?
local function get_root(fname)
  if mod_cache and fname:sub(1, #mod_cache) == mod_cache then
    local clients = util.get_lsp_clients { name = 'gopls' }
    if #clients > 0 then
      return clients[#clients].config.root_dir
    end
  end
  return util.root_pattern('go.work', 'go.mod', '.git')(fname)
end

---@brief
---
---https://github.com/golang/tools/tree/master/gopls
--
-- Google's lsp server for golang.
return {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_dir = function(bufnr, done_callback)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    -- see: https://github.com/neovim/nvim-lspconfig/issues/804
    if mod_cache then
      done_callback(get_root(fname))
      return
    end
    async.run_job({ 'go', 'env', 'GOMODCACHE' }, function(result)
      if result and result[1] then
        mod_cache = vim.trim(result[1])
      else
        mod_cache = vim.fn.system 'go env GOMODCACHE'
      end
      done_callback(get_root(fname))
    end)
  end,
}
