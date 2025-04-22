---@brief
---
--- https://github.com/AdaCore/ada_language_server
---
--- Installation instructions can be found [here](https://github.com/AdaCore/ada_language_server#Install).
---
--- Workspace-specific [settings](https://github.com/AdaCore/ada_language_server/blob/master/doc/settings.md) such as `projectFile` can be provided in a `.als.json` file at the root of the workspace.
--- Alternatively, configuration may be passed as a "settings" object to `vim.lsp.config('ada_ls', {})`:
---
--- ```lua
--- vim.lsp.config('ada_ls', {
---     settings = {
---       ada = {
---         projectFile = "project.gpr";
---         scenarioVariables = { ... };
---       }
---     }
--- })
--- ```

local util = require 'lspconfig.util'

return {
  cmd = { 'ada_language_server' },
  filetypes = { 'ada' },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    on_dir(util.root_pattern('Makefile', '.git', 'alire.toml', '*.gpr', '*.adc')(fname))
  end,
}
