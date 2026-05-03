---@brief
---
--- https://github.com/automattic/harper
---
--- The language server for Harper, the slim, clean language checker for developers.
---
--- See our [documentation](https://writewithharper.com/docs/integrations/neovim) for more information on settings.
---
--- In short, they should look something like this:
--- ```lua
--- vim.lsp.config('harper_ls', {
---   settings = {
---     ["harper-ls"] = {
---       userDictPath = "~/dict.txt"
---     }
---   },
--- })
--- ```

---@type vim.lsp.Config
return {
  cmd = { 'harper-ls', '--stdio' },
  filetypes = {
    'asciidoc',
    'c',
    'cmake',
    'clojure',
    'cpp',
    'cs',
    'dart',
    'gitcommit',
    'go',
    'groovy',
    'haskell',
    'html',
    'java',
    'javascript',
    'javascriptreact',
    'kotlin',
    'lua',
    'markdown',
    'nix',
    'org',
    'php',
    'python',
    'ruby',
    'rust',
    'scala',
    'sh',
    'solidity',
    'swift',
    'tex',
    'text',
    'toml',
    'typescript',
    'typescriptreact',
    'typst',
    'zig',
  },
  root_markers = { '.harper-dictionary.txt', '.git' },
}
