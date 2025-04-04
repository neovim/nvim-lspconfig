local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'fountain-lsp-server', '--stdio' },
    filetypes = {
      'fountain',
    },
    root_dir = function(fname)
      local root_files = { '.fountainrc' }
      return util.root_pattern(unpack(root_files))(fname)
        or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/oparaskos/fountain-lsp-server

This is a Language Server for fountain files, a simple markup syntax for writing, editing, and sharing screenplays in plain, human-readable text.

The language server is built on vscode-languageserver but should be flexible to use with other IDEs.

- Code Completions for Title Page attributes, scene headings, etc.
- CodeLens support for characters, scenes and locations.
- Statistics to be consumed by a webview, by character, location and scene; and more granularly by character gender and race.

If installed through NPM then there should be a binary fountain-lsp-server in node_modules/.bin

Otherwise you can use node dist/bundle.cjs.js [options] from the package file in GitHub releases or import dist/server from the node module to roll it into your own application.

The project introduces the concept of a .fountainrc file to specify additional details about characters, the schema for which is in the root of this project.

The extension will also attempt to guess gender of characters based on name, this only supports en and it locales and makes incorrect assumptions often (e.g. Sam is always regarded as a male name, even though it can be a shortened form of Samantha), but provides a reasonable basis as a default to be overridden.
    ]],
  },
}
