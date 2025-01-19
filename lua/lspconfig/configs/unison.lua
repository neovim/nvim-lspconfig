return {
  default_config = {
    cmd = { 'nc', 'localhost', os.getenv('UNISON_LSP_PORT') or '5757' },
    filetypes = { 'unison' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ '*.u' }, { path = fname, upward = true })[1])
    end,
    settings = {},
  },
  docs = {
    description = [[
https://github.com/unisonweb/unison/blob/trunk/docs/language-server.markdown


    ]],
  },
}
