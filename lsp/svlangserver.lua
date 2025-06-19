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

local function build_index()
  local params = {
    command = 'systemverilog.build_index',
  }
  vim.lsp.buf.execute_command(params)
end

local function report_hierarchy()
  local params = {
    command = 'systemverilog.report_hierarchy',
    arguments = { vim.fn.expand '<cword>' },
  }
  vim.lsp.buf.execute_command(params)
end

return {
  cmd = { 'svlangserver' },
  filetypes = { 'verilog', 'systemverilog' },
  root_markers = { '.svlangserver', '.git' },
  settings = {
    systemverilog = {
      includeIndexing = { '*.{v,vh,sv,svh}', '**/*.{v,vh,sv,svh}' },
    },
  },
  on_attach = function(_, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'LspSvlangserverBuildIndex', build_index, {
      desc = 'Instructs language server to rerun indexing',
    })
    vim.api.nvim_buf_create_user_command(bufnr, 'LspSvlangserverReportHierarchy', report_hierarchy, {
      desc = 'Generates hierarchy for the given module',
    })
  end,
}
