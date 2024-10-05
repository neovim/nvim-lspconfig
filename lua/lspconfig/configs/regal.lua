local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'regal', 'language-server' },
    filetypes = { 'rego' },
    root_dir = function(fname)
      return util.root_pattern '*.rego'(fname) or util.find_git_ancestor(fname)
    end,
    single_file_support = true,
    handlers = {
      ['regal/startDebugging'] = function(_, result)
        if not result then
          return nil, vim.lsp.rpc.rpc_response_error(vim.lsp.protocol.ErrorCodes.InvalidRequest)
        end

        local ok, dap = pcall(require, "dap")
        if not ok then
          return nil, vim.lsp.rpc.rpc_response_error(vim.lsp.protocol.ErrorCodes.InvalidRequest, "nvim-dap is not installed")
        end

        if not dap.session() == nil then
          return nil, vim.lsp.rpc.rpc_response_error(vim.lsp.protocol.ErrorCodes.InvalidRequest, "active debug session exists")
        end

        dap.run(vim.tbl_deep_extend("force", result, { bundlePaths = {"${workspaceFolder}"}}))

        return {ok = true}
      end,
    },
  },
  docs = {
    description = [[
https://github.com/StyraInc/regal

A linter for Rego, with support for running as an LSP server.

`regal` can be installed by running:
```sh
go install github.com/StyraInc/regal@latest
```
    ]],
    default_config = {
      root_dir = [[root_pattern("*.rego", ".git")]],
      single_file_support = true,
    },
  },
}
