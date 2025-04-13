---@brief
---
-- https://github.com/FoamScience/foam-language-server
--
-- `foam-language-server` can be installed via `npm`
-- ```sh
-- npm install -g foam-language-server
-- ```
return {
  cmd = { 'foam-ls', '--stdio' },
  filetypes = { 'foam', 'OpenFOAM' },
  root_dir = function(bufnr, on_dir)
    on_dir(vim.fs.root(bufnr, function(_, path)
      return vim.uv.fs_stat(path .. '/system/controlDict') ~= nil
    end))
  end,
}
