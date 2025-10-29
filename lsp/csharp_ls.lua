---@brief
---
--- https://github.com/razzmatazz/csharp-language-server
---
--- Language Server for C#.
---
--- csharp-ls requires the [dotnet-sdk](https://dotnet.microsoft.com/download) to be installed.
---
--- The preferred way to install csharp-ls is with `dotnet tool install --global csharp-ls`.

local util = require 'lspconfig.util'

---@type vim.lsp.Config
return {
  cmd = { 'csharp-ls' },
  cmd_cwd = vim.fs.root(0, {
    function(name, _)
      return name:match '%.slnx?$' ~= nil
    end,
    function(name, _)
      return name:match '%.csproj$' ~= nil
    end,
  }),
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    on_dir(util.root_pattern '*.sln'(fname) or util.root_pattern '*.slnx'(fname) or util.root_pattern '*.csproj'(fname))
  end,
  filetypes = { 'cs' },
  init_options = {
    AutomaticWorkspaceInit = true,
  },
}
