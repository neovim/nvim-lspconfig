local util = require 'lspconfig.util'

local meson_matcher = function(path)
  local pattern = 'meson.build'
  local f = vim.fn.glob(util.path.join(path, pattern))
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

local workspace_markers = { 'meson.build', '.git' }

return {
  default_config = {
    cmd = { 'vala-language-server' },
    filetypes = { 'vala', 'genie' },
    root_dir = util.root_pattern(unpack(workspace_markers)),
    single_file_support = true,
  },
  docs = {
    description = 'https://github.com/Prince781/vala-language-server',
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
