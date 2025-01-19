return {
  default_config = {
    cmd = { 'ols' },
    filetypes = { 'odin' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'ols.json', '.git', '*.odin' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
           https://github.com/DanielGavin/ols

           `Odin Language Server`.
        ]],
  },
}
