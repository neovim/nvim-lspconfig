return {
  default_config = {
    cmd = { 'qml-lsp' },
    filetypes = { 'qmljs' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ '*.qml' }, { path = fname, upward = true })[1])
    end,
  },
  docs = {
    description = [[
https://invent.kde.org/sdk/qml-lsp

LSP implementation for QML (autocompletion, live linting, etc. in editors)
        ]],
  },
}
