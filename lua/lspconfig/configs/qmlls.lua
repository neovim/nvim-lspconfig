return {
  default_config = {
    cmd = { 'qmlls' },
    filetypes = { 'qml', 'qmljs' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/qt/qtdeclarative

LSP implementation for QML (autocompletion, live linting, etc. in editors),
        ]],
  },
}
