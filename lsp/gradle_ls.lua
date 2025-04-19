---@brief
---
--- https://github.com/microsoft/vscode-gradle
---
--- Microsoft's lsp server for gradle files
---
--- If you're setting this up manually, build vscode-gradle using `./gradlew installDist` and point `cmd` to the `gradle-language-server` generated in the build directory

local bin_name = 'gradle-language-server'
if vim.fn.has 'win32' == 1 then
  bin_name = bin_name .. '.bat'
end

return {
  filetypes = { 'groovy' },
  root_markers = {
    'settings.gradle', -- Gradle (multi-project)
    'build.gradle', -- Gradle
  },
  cmd = { bin_name },
  -- gradle-language-server expects init_options.settings to be defined
  init_options = {
    settings = {
      gradleWrapperEnabled = true,
    },
  },
}
