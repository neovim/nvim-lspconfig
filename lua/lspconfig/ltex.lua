local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.ltex = {
  default_config = {
    cmd = { 'ltex-ls' },
    filetypes = { 'tex', 'bib', 'markdown' },
    root_dir = util.find_git_ancestor,
    settings = {
      ltex = {
        enabled = { 'latex', 'tex', 'bib', 'markdown' },
        checkFrequency = 'edit',
        language = 'en',
        diagnosticSeverity = 'information',
        setenceCacheSize = 2000,
        additionalRules = {
          enablePickyRules = true,
          motherTongue = 'en',
        },
        dictionary = {},
        disabledRules = {},
        hiddenFalsePositives = {},
      },
    },
  },
  docs = {
    package_json = 'https://raw.githubusercontent.com/valentjn/vscode-ltex/develop/package.json',
    description = [[
https://github.com/valentjn/ltex-ls

LTeX Language Server: LSP language server for LanguageTool 🔍✔️ with support for LaTeX 🎓, Markdown 📝, and others

To install, download the latest [release](https://github.com/valentjn/ltex-ls/releases) and ensure `ltex-ls` is on your path.

]],
  },
}
