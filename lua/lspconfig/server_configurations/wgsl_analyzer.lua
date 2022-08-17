local util = require 'lspconfig.util'

local bin_name = 'wgsl_analyzer'
local cmd = { bin_name }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name }
end
local localSettings = {
  customImports = {}, -- ['import'] = [[code to be imported]] or io.open("path to code")
  shaderDefs = {},
  trace = {
    extension = true,
    server = true,
  },
  inlayHints = {
    enabled = true,
    typeHints = true,
    parameterHints = true,
    structLayoutHints = true,
    typeVerbosity = "compact", -- "full", "inner"
  },
  diagnostics = {
    typeErrors = true,
    nagaParsingErrors = true,
    nagaValidationErrors = true,
    nagaVersion = "main", -- "0.8", "0.9"
  }
}


vim.lsp.handlers['wgsl-analyzer/requestConfiguration'] = function(err, result, ctx, config)
    return localSettings, nil
end

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'wgsl' },
    root_dir = util.root_pattern '.git',
    settings = localSettings ,
  },
  on_new_config = function(newConfig, _)
    vim.lsp.handlers['wgsl-analyzer/requestConfiguration'] = function(err, result, ctx, config)
      return newConfig.settings, nil
    end
  end,
  docs = {
    description = [[
https://github.com/wgsl-analyzer/wgsl-analyzer

`wgsl_analyzer` can be installed via `cargo`:
```sh
cargo install --git https://github.com/wgsl-analyzer/wgsl-analyzer wgsl_analyzer
```
]],
    default_config = {
      root_dir = [[root_pattern(".git"]],
    },
  },
}
