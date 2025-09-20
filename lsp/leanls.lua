---@brief
--- https://github.com/leanprover/lean4
---
--- Lean installation instructions can be found
--- [here](https://leanprover-community.github.io/get_started.html#regular-install).
---
--- The Lean language server is included in any Lean installation and
--- does not require any additional packages.
---
--- Note: that if you're using [lean.nvim](https://github.com/Julian/lean.nvim),
--- that plugin fully handles the setup of the Lean language server,
--- and you shouldn't set up `leanls` both with it and `lspconfig`.

---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local local_cmd = { 'lake', 'serve', '--', config.root_dir }
    return vim.lsp.rpc.start(local_cmd, dispatchers)
  end,
  filetypes = { 'lean' },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    fname = vim.fs.normalize(fname)
    -- check if inside lean stdlib
    local stdlib_dir
    do
      local _, endpos = fname:find '/lean/library'
      if endpos then
        stdlib_dir = fname:sub(1, endpos)
      end
    end
    if not stdlib_dir then
      local _, endpos = fname:find '/lib/lean'
      if endpos then
        stdlib_dir = fname:sub(1, endpos)
      end
    end

    on_dir(
      vim.fs.root(fname, { 'lakefile.toml', 'lakefile.lean', 'lean-toolchain' })
        or stdlib_dir
        or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    )
  end,
}
