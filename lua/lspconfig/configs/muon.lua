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
