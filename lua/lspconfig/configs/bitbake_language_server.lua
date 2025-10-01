return {
  default_config = {
    cmd = { 'bitbake-language-server' },
    filetypes = { 'bitbake' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
🛠️ bitbake language server
]],
  },
}
