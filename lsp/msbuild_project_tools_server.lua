---@brief
---
--- https://github.com/tintoy/msbuild-project-tools-server/
---
--- MSBuild Project Tools Server can be installed by following the README.MD on the above repository.
---
--- Example config:
--- ```lua
--- vim.lsp.config('msbuild_project_tools_server', {
---   cmd = {'dotnet', '/path/to/server/MSBuildProjectTools.LanguageServer.Host.dll'}
--- })
--- ```
---
--- There's no builtin filetypes for msbuild files, would require some filetype aliases:
---
--- ```lua
--- vim.filetype.add({
---   extension = {
---     props = 'msbuild',
---     tasks = 'msbuild',
---     targets = 'msbuild',
---   },
---   pattern = {
---     [ [[.*\..*proj]] ] = 'msbuild',
---   },
--- })
--- ```
---
--- Optionally tell treesitter to treat `msbuild` as `xml` so you can get syntax highlighting if you have the treesitter-xml-parser installed.
---
--- ```lua
--- vim.treesitter.language.register('xml', { 'msbuild' })
--- ```

local host_dll_name = 'MSBuildProjectTools.LanguageServer.Host.dll'

return {
  filetypes = { 'msbuild' },
  root_dir = function(bufnr, on_dir)
    on_dir(vim.fs.root(bufnr, function(name, _)
      local patterns = { '*.sln', '*.slnx', '*.*proj', '.git' }
      for _, pattern in ipairs(patterns) do
        if vim.glob.to_lpeg(pattern):match(name) ~= nil then
          return true
        end
      end
      return false
    end))
  end,
  init_options = {},
  cmd = { 'dotnet', host_dll_name },
}
