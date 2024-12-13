return {
  default_config = {
    filetypes = { 'bsl', 'os' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
    https://github.com/1c-syntax/bsl-language-server

    Language Server Protocol implementation for 1C (BSL) - 1C:Enterprise 8 and OneScript languages.

    ]],
  },
}
