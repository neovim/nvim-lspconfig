---@brief
---
--- https://github.com/FoamScience/foam-language-server
---
--- `foam-language-server` can be installed via `npm`
--- ```sh
--- npm install -g foam-language-server
--- ```

return {
  cmd = { 'foam-ls', '--stdio' },
  filetypes = { 'foam', 'OpenFOAM' },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    on_dir(vim.iter(vim.fs.parents(fname)):find(function(path)
      if vim.uv.fs_stat(path .. '/system/controlDict') then
        return path
      end
    end))
  end,
}
