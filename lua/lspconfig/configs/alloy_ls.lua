return {
  default_config = {
    cmd = { 'alloy', 'lsp' },
    filetypes = { 'alloy' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/AlloyTools/org.alloytools.alloy

Alloy is a formal specification language for describing structures and a tool for exploring them.
]],
  },
}
