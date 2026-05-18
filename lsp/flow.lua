---@brief
---
--- https://flow.org/
--- https://github.com/facebook/flow
---
--- See below for how to setup Flow itself.
--- https://flow.org/en/docs/install/
---
--- See below for lsp command options.
---
--- ```sh
--- npx flow lsp --help
--- ```

---@type vim.lsp.Config
return {
  cmd = function(dispatchers)
    local cmd
    if vim.fn.executable('flow') == 1 then
      cmd = { 'flow', 'lsp' }
    else
      -- Try project-local binary before falling back to npx
      local file_dir = vim.fn.expand('%:p:h')
      local config = vim.fn.findfile('.flowconfig', file_dir .. ';')
      local root_dir = config ~= '' and vim.fn.fnamemodify(config, ':p:h') or vim.fn.getcwd()
      local flow_bin = root_dir .. '/node_modules/.bin/flow'
      if vim.fn.executable(flow_bin) == 1 then
        cmd = { flow_bin, 'lsp' }
      else
        cmd = { 'npx', '--no-install', 'flow', 'lsp' }
      end
    end
    return vim.lsp.rpc.start(cmd, dispatchers)
  end,
  filetypes = { 'javascript', 'javascriptreact' },
  root_markers = { '.flowconfig' },
}
