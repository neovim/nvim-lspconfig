return {
  default_config = {
    cmd = { 'stylua-3p-language-server' },
    filetypes = { 'lua' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ '.stylua.toml', 'stylua.toml' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/antonk52/lua-3p-language-servers

3rd party Language Server for Stylua lua formatter
]],
  },
}
