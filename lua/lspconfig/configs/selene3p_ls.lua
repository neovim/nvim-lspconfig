return {
  default_config = {
    cmd = { 'selene-3p-language-server' },
    filetypes = { 'lua' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'selene.toml' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/antonk52/lua-3p-language-servers

3rd party Language Server for Selene lua linter
]],
  },
}
