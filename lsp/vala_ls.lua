---@brief
---
--- https://github.com/Prince781/vala-language-server

local meson_matcher = function(path)
  local pattern = 'meson.build'
  local f = vim.fn.glob(table.concat({ path, pattern }, '/'))
  if f == '' then
    return nil
  end
  for line in io.lines(f) do
    -- skip meson comments
    if not line:match '^%s*#.*' then
      local str = line:gsub('%s+', '')
      if str ~= '' then
        if str:match '^project%(' then
          return path
        else
          break
        end
      end
    end
  end
end

return {
  cmd = { 'vala-language-server' },
  filetypes = { 'vala', 'genie' },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root = vim.iter(vim.fs.parents(fname)):find(meson_matcher)
    on_dir(root or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1]))
  end,
}
