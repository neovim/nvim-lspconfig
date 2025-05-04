---@brief
---
--- https://github.com/leanprover/lean-client-js/tree/master/lean-language-server
---
--- Lean installation instructions can be found
--- [here](https://leanprover-community.github.io/get_started.html#regular-install).
---
--- Once Lean is installed, you can install the Lean 3 language server by running
--- ```sh
--- npm install -g lean-language-server
--- ```
---
--- Note: that if you're using [lean.nvim](https://github.com/Julian/lean.nvim),
--- that plugin fully handles the setup of the Lean language server,
--- and you shouldn't set up `lean3ls` both with it and `lspconfig`.

return {
  cmd = { 'lean-language-server', '--stdio', '--', '-M', '4096', '-T', '100000' },
  filetypes = { 'lean3' },
  offset_encoding = 'utf-32',
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    fname = vim.fs.normalize(fname)
    -- check if inside elan stdlib
    local stdlib_dir
    do
      local _, endpos = fname:find '/lean/library'
      if endpos then
        stdlib_dir = fname:sub(1, endpos)
      end
    end

    on_dir(
      vim.fs.root(fname, { 'leanpkg.toml', 'leanpkg.path' })
        or stdlib_dir
        or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    )
  end,
}
