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
    local cmd = nil
    if vim.fn.executable('flow') then
      cmd = { 'flow', 'lsp' }
    else
      cmd = { 'npx', '--no-install', 'flow', 'lsp' }
    end

    return vim.lsp.rpc.start(cmd, dispatchers)
  end,
  filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx' },
  root_markers = { '.flowconfig' },
}
