---@brief
---
--- F# Language Server
--- https://github.com/faldor20/fsharp-language-server
---
--- An implementation of the language server protocol using the F# Compiler Service.
---
--- Build the project from source and override the command path to location of DLL.
---
--- If filetype determination is not already performed by an available plugin ([PhilT/vim-fsharp](https://github.com/PhilT/vim-fsharp), [fsharp/vim-fsharp](https://github.com/fsharp/vim-fsharp), and [adelarsq/neofsharp.vim](https://github.com/adelarsq/neofsharp.vim).
--- ), then the following must be added to initialization configuration:
---
---
--- `autocmd BufNewFile,BufRead *.fs,*.fsx,*.fsi set filetype=fsharp`

return {
  cmd = { 'dotnet', 'FSharpLanguageServer.dll' },
  root_dir = function(bufnr, on_dir)
    on_dir(vim.fs.root(bufnr, function(name, _)
      local patterns = { '*.sln', '*.fsproj', '.git' }
      for _, pattern in ipairs(patterns) do
        if vim.glob.to_lpeg(pattern):match(name) ~= nil then
          return true
        end
      end
      return false
    end))
  end,
  filetypes = { 'fsharp' },
  init_options = {
    AutomaticWorkspaceInit = true,
  },
  settings = {},
}
