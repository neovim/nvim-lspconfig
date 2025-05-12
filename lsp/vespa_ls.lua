---@brief
---
--- https://github.com/vespa-engine/vespa/tree/master/integration/schema-language-server
---
--- Vespa Language Server provides LSP features such as completion, diagnostics,
--- and go-to-definition for Vespa schema files (`.sd`), profile files (`.profile`),
--- and YQL query files (`.yql`).
---
--- This language server requires Java 17 or higher. You can build the jar from source.
---
--- You can override the default command by manually configuring it like this:
---
--- ```lua
--- vim.lsp.config('vespa_ls', {
---   cmd = { 'java', '-jar', '/path/to/vespa-language-server.jar' },
--- })
--- ```
---
--- The project root is determined based on the presence of a `.git` directory.
---
--- To make Neovim recognize the proper filetypes, add the following setting in `init.lua`:
---
---     vim.filetype.add {
---       extension = {
---         profile = 'sd',
---         sd = 'sd',
---         yql = 'yql',
---       },
---     }

return {
  cmd = { 'java', '-jar', 'vespa-language-server.jar' },
  filetypes = { 'sd', 'profile', 'yql' },
  root_markers = {
    '.git',
  },
}
