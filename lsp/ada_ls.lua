local util = require 'lspconfig.util'

---@brief
---
---https://github.com/AdaCore/ada_language_server
--
-- Installation instructions can be found [here](https://github.com/AdaCore/ada_language_server#Install).
--
-- Can be configured by passing a "settings" object to `ada_ls.setup{}`:
--
-- ```lua
-- vim.lsp.config('ada_ls', {
--     settings = {
--       ada = {
--         projectFile = "project.gpr";
--         scenarioVariables = { ... };
--       }
--     }
-- })
-- ```
return {
  cmd = { 'ada_language_server' },
  filetypes = { 'ada' },
  root_dir = function(bufnr, done_callback)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    done_callback(util.root_pattern('Makefile', '.git', '*.gpr', '*.adc')(fname))
  end,
}
