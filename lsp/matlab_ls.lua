---@brief
---
--- https://github.com/mathworks/MATLAB-language-server
---
--- MATLAB® language server implements the Microsoft® Language Server Protocol for the MATLAB language.
return {
  cmd = { 'matlab-language-server', '--stdio' },
  filetypes = { 'matlab' },
  root_dir = function(bufnr, callback)
    local root_dir = vim.fs.root(bufnr, '.git')
    if root_dir then
      callback(root_dir)
    else
      callback(vim.env.PWD)
    end
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
