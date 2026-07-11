---@brief
---
--- https://doc.qt.io/qt-6/qtqml-tooling-qmlls.html
---
--- > QML Language Server is a tool shipped with Qt that helps you write code in your favorite (LSP-supporting) editor.
---
--- Source in the [QtDeclarative repository](https://code.qt.io/cgit/qt/qtdeclarative.git/)
---
--- Note: On some distros, the cmd of qmlls is `qmlls6`. **You can do this by changing `cmd` in your call to `vim.lsp.config`**

---@type vim.lsp.Config
return {
  cmd = { 'qmlls' },
  filetypes = { 'qml', 'qmljs' },
  root_markers = { '.git' },
}
