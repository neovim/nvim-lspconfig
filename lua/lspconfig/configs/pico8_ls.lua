return {
  default_config = {
    cmd = { 'pico8-ls', '--stdio' },
    filetypes = { 'p8' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ '*.p8' }, { path = fname, upward = true })[1])
    end,
    settings = {},
  },
  docs = {
    description = [[
https://github.com/japhib/pico8-ls

Full language support for the PICO-8 dialect of Lua.
]],
  },
}
