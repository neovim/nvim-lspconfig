local async = require('lspconfig.async')

---@brief
---
---https://muon.build
return {
  cmd = { 'muon', 'analyze', 'lsp' },
  filetypes = { 'meson' },
  root_dir = function(bufnr, done_callback)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    async.run_job({ 'muon', 'analyze', 'root-for', fname }, function(res)
      if res[1] then
        done_callback(vim.trim(res[1]))
        return
      end

      done_callback(nil)
    end)
  end,
}
