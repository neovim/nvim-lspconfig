---@brief
---
--- https://github.com/VisualText/vscode-nlp/tree/master/language-server
---
--- `nlpplus-language-server`, the language server for NLP++, the programming language for natural
--- language processing (https://visualtext.org/nlp/). It can be installed via `npm`:
--- ```sh
--- npm i -g nlpplus-language-server
--- ```
---
--- Open the analyzer folder (the one that contains `spec/`) so cross-pass navigation finds every pass.
---
--- Until Neovim detects NLP++ pass files on its own, register the filetype:
--- ```lua
--- vim.filetype.add({ extension = { nlp = 'nlp' } })
--- ```

---@type vim.lsp.Config
return {
  cmd = { 'nlpplus-language-server', '--stdio' },
  filetypes = { 'nlp' },
  root_markers = { 'spec', '.git' },
}
