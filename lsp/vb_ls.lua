---@brief
---
--- https://github.com/CoolCoderSuper/visualbasic-language-server
---
--- Language Server for VB.NET.
---
--- vb-ls requires the [dotnet-sdk](https://dotnet.microsoft.com/download) to be installed.
---
--- The preferred way to install vb-ls is with `dotnet tool install --global vb-ls`.
--- Additionally you need to register the .vb extension with the vbnet filetype.
--- A plugin that does this as well as improved syntax highlighting is [vbnet.nvim](https://github.com/CoolCoderSuper/vbnet.nvim).

local util = require 'lspconfig.util'

return {
  cmd = { 'vb-ls' },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    on_dir(util.root_pattern '*.sln'(fname) or util.root_pattern '*.vbproj'(fname) or util.root_pattern '*.slnx'(fname))
  end,
  filetypes = { 'vbnet' },
  init_options = {
    AutomaticWorkspaceInit = true,
  },
}
