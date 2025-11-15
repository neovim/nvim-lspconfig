-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- This config is DEPRECATED.
-- Use the configs in `lsp/` instead (requires Nvim 0.11).
--
-- ALL configs in `lua/lspconfig/configs/` will be DELETED.
-- They exist only to support Nvim 0.10 or older.
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
local async = require('lspconfig.async')

return {
  default_config = {
    cmd = { 'muon', 'analyze', 'lsp' },
    filetypes = { 'meson' },
    root_dir = function(fname)
      local res = async.run_command({ 'muon', 'analyze', 'root-for', fname })
      if res[1] then
        return vim.trim(res[1])
      end
    end,
  },
  docs = {
    description = [[
https://muon.build
]],
    default_config = {},
  },
}
