---@brief
---
--- https://github.com/FoamScience/foam-language-server
---
--- `foam-language-server` can be installed via `npm`
--- ```sh
--- npm install -g foam-language-server
--- ```

---@type vim.lsp.Config
return {
  cmd = { 'foam-ls', '--stdio' },
  filetypes = { 'foam', 'OpenFOAM' },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    for path in vim.fs.parents(fname) do
      if vim.uv.fs_stat(path .. '/system/controlDict') then
        on_dir(path)
        return
      end
    end
    local git_root = vim.fs.root(bufnr, { '.git' })
    if git_root then
      on_dir(git_root)
      return
    end
    on_dir(vim.fs.dirname(fname))
  end,
}
