return {
  default_config = {
    cmd = { 'matlab-language-server', '--stdio' },
    filetypes = { 'matlab' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = false,
    settings = {
      MATLAB = {
        indexWorkspace = false,
        installPath = '',
        matlabConnectionTiming = 'onStart',
        telemetry = true,
      },
    },
  },
  docs = {
    description = [[
https://github.com/mathworks/MATLAB-language-server

MATLAB® language server implements the Microsoft® Language Server Protocol for the MATLAB language.
]],
  },
}
