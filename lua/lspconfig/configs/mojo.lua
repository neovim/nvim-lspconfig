return {
  default_config = {
    cmd = { 'mojo-lsp-server' },
    filetypes = { 'mojo' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/modularml/mojo

`mojo-lsp-server` can be installed [via Modular](https://developer.modular.com/download)

Mojo is a new programming language that bridges the gap between research and production by combining Python syntax and ecosystem with systems programming and metaprogramming features.
]],
  },
}
