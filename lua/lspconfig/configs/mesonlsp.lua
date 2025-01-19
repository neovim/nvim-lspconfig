return {
  default_config = {
    cmd = { 'mesonlsp', '--lsp' },
    filetypes = { 'meson' },
    root_dir = function(fname)
      return vim.fs.dirname(
        vim.fs.find({ 'meson.build', 'meson_options.txt', 'meson.options', '.git' }, { path = fname, upward = true })[1]
      )
    end,
  },
  docs = {
    description = [[
https://github.com/JCWasmx86/mesonlsp

An unofficial, unendorsed language server for meson written in C++
]],
  },
}
