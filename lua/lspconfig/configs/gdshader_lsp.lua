return {
  default_config = {
    cmd = { 'gdshader-lsp', '--stdio' },
    filetypes = { 'gdshader', 'gdshaderinc' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'project.godot' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://github.com/godofavacyn/gdshader-lsp

A language server for the Godot Shading language.
]],
  },
}
