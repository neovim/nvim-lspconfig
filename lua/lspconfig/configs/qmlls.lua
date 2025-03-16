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
https://doc.qt.io/qt-6/qtqml-tooling-qmlls.html

> QML Language Server is a tool shipped with Qt that helps you write code in your favorite (LSP-supporting) editor.

Source in the [QtDeclarative repository](https://code.qt.io/cgit/qt/qtdeclarative.git/)
        ]],
  },
}
