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
  cmd = function(dispatchers, config)
    local cmd
    if vim.fn.executable('flow') == 1 then
      cmd = { 'flow', 'lsp' }
    else
      local flow_bin = (config or {}).root_dir and vim.fs.joinpath(config.root_dir, 'node_modules/.bin/flow')
      if flow_bin and vim.fn.executable(flow_bin) == 1 then
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
