local util = require 'lspconfig.util'

---@brief
---
---https://github.com/razzmatazz/csharp-language-server
--
-- Language Server for C#.
--
-- csharp-ls requires the [dotnet-sdk](https://dotnet.microsoft.com/download) to be installed.
--
-- The preferred way to install csharp-ls is with `dotnet tool install --global csharp-ls`.
return {
  cmd = { 'csharp-ls' },
  root_dir = function(bufnr, done_callback)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    done_callback(util.root_pattern '*.sln'(fname) or util.root_pattern '*.csproj'(fname))
  end,
  filetypes = { 'cs' },
  init_options = {
    AutomaticWorkspaceInit = true,
  },
}
