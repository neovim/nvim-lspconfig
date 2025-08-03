---@brief
---
--- https://github.com/mathworks/MATLAB-language-server
---
--- MATLAB® language server implements the Microsoft® Language Server Protocol for the MATLAB language.
---
--- Make sure to set `MATLAB.installPath` to your MATLAB path, e.g.:
--- ```lua
--- settings = {
---   MATLAB = {
---     ...
---     installPath = '/usr/local/MATLAB/R2023a',
---     ...
---   },
--- },
--- ```
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
      installPath = '', -- NOTE: Set this to your MATLAB installation path.
      matlabConnectionTiming = 'onStart',
      telemetry = true,
    },
  },
}
