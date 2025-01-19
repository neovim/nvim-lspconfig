return {
  default_config = {
    cmd = { 'ttags', 'lsp' },
    filetypes = { 'ruby', 'rust', 'javascript', 'haskell' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ '.git' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/npezza93/ttags
    ]],
  },
}
