---@brief
---
--- https://github.com/laravel/lsp
---
--- Laravel LSP provides framework-aware editor features for Laravel applications.
---
--- Install Laravel LSP globally with Composer:
---
--- ```sh
--- composer global require laravel/lsp
--- ```
---
--- Ensure Composer's global bin directory is on `$PATH`.

---@type vim.lsp.Config
return {
  cmd = { 'laravel-lsp' },
  filetypes = { 'php', 'blade' },
  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, 'artisan')
    if root then
      on_dir(root)
    end
  end,
}
