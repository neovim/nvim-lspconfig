local util = require 'lspconfig.util'

local bin_name = 'gradle-language-server'
if vim.fn.has 'win32' == 1 then
  bin_name = bin_name .. '.bat'
end

local root_files = {
  'settings.gradle', -- Gradle (multi-project)
  'settings.gradle.kts', -- Gradle (multi-project)
}

local fallback_root_files = {
  'build.gradle', -- Gradle
  'build.gradle.kts', -- Gradle
}

return {
  default_config = {
    filetypes = { 'kotlin', 'groovy' },
    root_dir = function(fname)
      return util.root_pattern(unpack(root_files))(fname) or util.root_pattern(unpack(fallback_root_files))(fname)
    end,
    cmd = { bin_name },
  },
  docs = {
    default_config = {
      root_dir = [[root_pattern("settings.gradle", "settings.gradle.kts")]],
      cmd = { 'gradle-language-server' },
    },
  },
}
