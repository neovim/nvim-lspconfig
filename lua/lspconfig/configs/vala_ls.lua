local util = require 'lspconfig.util'

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
  default_config = {
    cmd = { 'vala-language-server' },
    filetypes = { 'vala', 'genie' },
    root_dir = function(fname)
      local root = util.search_ancestors(fname, meson_matcher)
      return root or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = 'https://github.com/Prince781/vala-language-server',
  },
}
