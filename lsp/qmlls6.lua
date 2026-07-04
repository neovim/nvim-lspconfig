---@brief
---
---https://doc.qt.io/qt-6/qtqml-tooling-qmlls.html
---
--- > An implementation of the Language Server Protocol for QML
---
---Source in the [QtDeclarative repository](https://code.qt.io/cgit/qt/qtlanguageserver.git)


---@type vim.lsp.Config
return{
  cmd = { 'qmlls6' },
  filetypes = { 'qml', 'qmljs' },
  root_markers = { '.git' },
}
