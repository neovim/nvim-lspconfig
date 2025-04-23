---@brief
---
--- https://sr.ht/~xerool/fennel-ls/
---
--- A language server for fennel.
---
--- fennel-ls is configured using the closest file to your working directory named `flsproject.fnl`.
--- All fennel-ls configuration options [can be found here](https://git.sr.ht/~xerool/fennel-ls/tree/HEAD/docs/manual.md#configuration).

return {
  cmd = { 'fennel-ls' },
  filetypes = { 'fennel' },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local has_fls_project_cfg = function(path)
      local fnlpath = vim.fs.joinpath(path, 'flsproject.fnl')
      return (vim.uv.fs_stat(fnlpath) or {}).type == 'file'
    end
    on_dir(vim.iter(vim.fs.parents(fname)):find(has_fls_project_cfg) or vim.fs.root(0, '.git'))
  end,
  settings = {},
  capabilities = {
    offsetEncoding = { 'utf-8', 'utf-16' },
  },
}
