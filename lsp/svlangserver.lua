---@brief
---
--- https://github.com/imc-trading/svlangserver
---
--- Language server for SystemVerilog.
---
--- `svlangserver` can be installed via `npm`:
---
--- ```sh
--- $ npm install -g @imc-trading/svlangserver
--- ```

return {
  cmd = { 'svlangserver' },
  filetypes = { 'verilog', 'systemverilog' },
  root_markers = { '.svlangserver', '.git' },
  settings = {
    systemverilog = {
      includeIndexing = { '*.{v,vh,sv,svh}', '**/*.{v,vh,sv,svh}' },
    },
  },
  ---@param client vim.lsp.Client
  ---@param bufnr integer
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'LspSvlangserverBuildIndex', function()
      client:exec_cmd({
        title = 'Build Index',
        command = 'systemverilog.build_index',
      }, { bufnr = bufnr })
    end, {
      desc = 'Instructs language server to rerun indexing',
    })
    vim.api.nvim_buf_create_user_command(bufnr, 'LspSvlangserverReportHierarchy', function()
      client:exec_cmd({
        title = 'Build Index',
        command = 'systemverilog.build_index',
        arguments = { vim.fn.expand '<cword>' },
      }, { bufnr = bufnr })
    end, {
      desc = 'Generates hierarchy for the given module',
    })
  end,
}
