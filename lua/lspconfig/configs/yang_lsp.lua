return {
  default_config = {
    cmd = { 'yang-language-server' },
    filetypes = { 'yang' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/TypeFox/yang-lsp

A Language Server for the YANG data modeling language.
]],
  },
}
