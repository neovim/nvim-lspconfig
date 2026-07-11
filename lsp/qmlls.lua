---@brief
---
--- https://doc.qt.io/qt-6/qtqml-tooling-qmlls.html
---
--- > QML Language Server is a tool shipped with Qt that helps you write code in your favorite (LSP-supporting) editor.
---
--- Source in the [QtDeclarative repository](https://code.qt.io/cgit/qt/qtdeclarative.git/)
---
--- Note: On some distros, the cmd of qmlls is `qmlls6`. **You can fix this by adding `vim.lsp.config('qmlls', { cmd = 'qmlls6' })`**

---@type vim.lsp.Config
return {
  cmd = { 'qmlls' },
  filetypes = { 'qml', 'qmljs' },
  root_markers = { '.git' },
}
