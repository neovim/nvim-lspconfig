local util = require 'lspconfig.util'

local bin_name = 'wgsl_analyzer'
local cmd = { bin_name }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name }
end
local localSettings = {
    customImports = {},
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
        typeVerbosity = "compact",
    },
    diagnostics = {
        typeErrors = true,
        nagaParsingErrors = true,
        nagaValidationErrors = true,
        nagaVersion = "main",
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
    settings = {},
  },
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
