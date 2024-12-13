return {
  default_config = {
    cmd = { 'facility-language-server' },
    filetypes = { 'fsd' },
    single_file_support = true,
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/FacilityApi/FacilityLanguageServer

Facility language server protocol (LSP) support.
]],
  },
}
