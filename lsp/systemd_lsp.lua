---@brief
---
--- https://github.com/JFryy/systemd-lsp
---
--- A Language Server Protocol (LSP) implementation for Systemd unit files,
--- providing editing support with syntax highlighting,
--- diagnostics, autocompletion, and documentation.
---
--- `systemd-lsp` can be installed via `cargo`:
--- ```sh
--- cargo install systemd-lsp
--- ```
---
--- A language server implementation for Systemd unit files made in Rust.
---
--- > [!NOTE]
--- >
--- > If you want this LSP to accurately activate for any Systemd files,
--- > make sure to use the following autocmd:
---
--- ```lua
--- vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile' }, {
---  group = vim.api.nvim_create_augroup('systemd-filetypes', { clear = true }),
--   pattern = {
--     '*.service',
--     '*.mount',
--     '*.device',
--     '*.nspawn',
--     '*.target',
--     '*.timer',
--     '*.path',
--     '*.slice',
--     '*.socket',
--   },
--   callback = function()
--     local bufnr = vim.api.nvim_get_current_buf()
--     vim.bo[bufnr].filetype = 'systemd'
--   end,
--   desc = 'Set filetype to systemd for systemd unit files',
-- })
--- ```

---@type vim.lsp.Config
return {
  cmd = { 'systemd-lsp' },
  filetypes = { 'systemd' },
  -- The 'root_markers' logic is now incorporated into the 'root_dir' function for more flexible matching.
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    -- Define the systemd unit file extensions that mark a root directory.
    local systemd_extensions = { '.service', '.mount', '.device', '.nspawn', '.target', '.timer' }

    ---@param path string?
    ---@return boolean
    local function find_root_by_markers(path)
      --- @diagnostic disable-next-line: undefined-field
      -- Check for common project root markers like a '.git' directory.
      if (vim.uv.fs_stat(vim.fs.joinpath(path, '.git')) or {}).type == 'directory' then
        return true
      end

      -- Check if the current directory contains any file with the specified systemd extensions.
      for _, ext in ipairs(systemd_extensions) do
        ---Use vim.fn.glob to find any file in 'path' ending with the current extension.
        ---@type integer
        local files = vim.fn.glob(vim.fs.joinpath(path, '*' .. ext), false, true)
        if #files > 0 then
          return true
        end
      end
      return false
    end

    -- Traverse up the directory tree from the current file's location to find the project root.
    -- If no specific root is found, default to searching for a .git root from the current buffer.
    on_dir(vim.iter(vim.fs.parents(fname)):find(find_root_by_markers) or vim.fs.root(0, '.git'))
  end,
}
