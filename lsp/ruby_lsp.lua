---@brief
---
--- https://shopify.github.io/ruby-lsp/
---
--- This gem is an implementation of the language server protocol specification for
--- Ruby, used to improve editor features.
---
--- Install the gem. There's no need to require it, since the server is used as a
--- standalone executable.
---
--- ```sh
--- gem install ruby-lsp
--- ```

---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    return vim.lsp.rpc.start(
      { 'ruby-lsp' },
      dispatchers,
      config and config.root_dir and { cwd = config.cmd_cwd or config.root_dir }
    )
  end,
  filetypes = { 'ruby', 'eruby' },
  root_markers = { 'Gemfile', '.git' },
  init_options = {
    formatter = 'auto',
  },
  reuse_client = function(client, config)
    config.cmd_cwd = config.root_dir
    return client.config.cmd_cwd == config.cmd_cwd
  end,
}
