---@brief
---
--- Language server for programs written in Hack
--- https://hhvm.com/
--- https://github.com/facebook/hhvm
--- See below for how to setup HHVM & typechecker:
--- https://docs.hhvm.com/hhvm/getting-started/getting-started

---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    return vim.lsp.rpc.start({ 'hh_client', 'lsp', '--from', 'neovim' }, dispatchers, {
      -- cwd should be the same as project root, not neovim's process cwd
      cwd = config.root_dir,
    })
  end,

  filetypes = { 'php', 'hack' },
  root_markers = { '.hhconfig' },
}
