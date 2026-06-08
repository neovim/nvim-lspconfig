---@brief
---
--- https://github.com/fallow-rs/fallow
---
--- Codebase intelligence for TypeScript and JavaScript.

---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local cmd = 'fallow-lsp'
    if (config or {}).root_dir then
      local local_cmd = vim.fs.joinpath(config.root_dir, 'node_modules/.bin', cmd)
      if vim.fn.executable(local_cmd) == 1 then
        cmd = local_cmd
      end
    end
    return vim.lsp.rpc.start({ cmd }, dispatchers)
  end,
  filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
  root_markers = { '.fallowrc.json', '.git' },
  init_options = {
    -- Every issue type is enabled by default. List only the ones you
    -- want to turn off; any key you omit stays enabled.
    -- issueTypes = {
    --   ['circular-dependencies'] = false,
    -- },
  },
}
