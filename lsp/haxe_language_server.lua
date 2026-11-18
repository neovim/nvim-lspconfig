---@brief
---
--- https://github.com/vshaxe/haxe-language-server
---
--- The Haxe language server can be built from the project's root directory:
---
--- ```sh
--- npm ci
--- npx lix run vshaxe-build -t language-server
--- ```
---
--- This creates `bin/server.js`. The server requires Haxe 3.4.0 or newer.
--- Configure the path to the server before enabling it:
---
--- ```lua
--- vim.lsp.config('haxe_language_server', {
---   cmd = { 'node', '/path/to/bin/server.js' },
--- })
--- vim.lsp.enable('haxe_language_server')
--- ```
---
--- By default, the first `.hxml` file found in the project root supplies the
--- compiler arguments. To choose a different file or pass arguments directly:
---
--- ```lua
--- vim.lsp.config('haxe_language_server', {
---   init_options = {
---     displayArguments = { 'build.hxml' },
---   },
--- })
--- ```

local util = require 'lspconfig.util'

---@type vim.lsp.Config
return {
  cmd = { 'haxe-language-server' },
  filetypes = { 'haxe' },
  workspace_required = true,
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    on_dir(util.root_pattern('*.hxml', '.git')(fname))
  end,
  settings = {
    haxe = {
      executable = 'haxe',
    },
  },
  init_options = {},
  before_init = function(_, config)
    if config.init_options.displayArguments or not config.root_dir then
      return
    end

    local hxml = vim.fs.find(function(name)
      return name:match('%.hxml$') ~= nil
    end, { path = config.root_dir, type = 'file' })[1]
    if hxml then
      vim.notify('Using HXML: ' .. hxml)
      config.init_options.displayArguments = { hxml }
    end
  end,
}
