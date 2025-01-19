local cmd = { 'scheme-langserver', '~/.scheme-langserver.log', 'enable', 'disable' }
local root_files = {
  'Akku.manifest',
  '.git',
}

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'scheme' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ unpack(root_files) }, { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/ufo5260987423/scheme-langserver
`scheme-langserver`, a language server protocol implementation for scheme.
And for nvim user, please add .sls to scheme file extension list.
]],
  },
}
