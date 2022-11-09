local util = require 'lspconfig.util'

local workspace_markers = { 'build.sbt', 'build.sc', 'build.gradle', 'pom.xml' }

return {
  default_config = {
    cmd = { 'metals' },
    filetypes = { 'scala' },
    workspace_markers = workspace_markers,
    root_dir = util.root_pattern(unpack(workspace_markers)),
    message_level = vim.lsp.protocol.MessageType.Log,
    init_options = {
      statusBarProvider = 'show-message',
      isHttpEnabled = true,
      compilerOptions = {
        snippetAutoIndent = false,
      },
    },
    capabilities = {
      workspace = {
        configuration = false,
      },
    },
  },
  docs = {
    description = [[
https://scalameta.org/metals/

Scala language server with rich IDE features.

See full instructions in the Metals documentation:

https://scalameta.org/metals/docs/editors/vim#using-an-alternative-lsp-client

Note: that if you're using [nvim-metals](https://github.com/scalameta/nvim-metals), that plugin fully handles the setup and installation of Metals, and you shouldn't set up Metals both with it and `lspconfig`.

To install Metals, make sure to have [coursier](https://get-coursier.io/docs/cli-installation) installed, and once you do you can install the latest Metals with `cs install metals`.
]],
    default_config = {
      workspace_markers = workspace_markers,
    },
  },
}
