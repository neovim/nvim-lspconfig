---@brief
---
--- https://github.com/mathworks/MATLAB-language-server
---
--- MATLAB® language server implements the Microsoft® Language Server Protocol for the MATLAB language.
return {
  cmd = { 'matlab-language-server', '--stdio' },
  filetypes = { 'matlab' },
  root_dir = function(bufnr, on_dir)
    local root_dir = vim.fs.root(bufnr, '.git')
    on_dir(root_dir or vim.fn.getcwd())
  end,
  settings = {
    MATLAB = {
      indexWorkspace = true,
      installPath = '',
      matlabConnectionTiming = 'onStart',
      telemetry = true,
    },
  },
}
