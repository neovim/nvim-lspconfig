---@brief
---
--- https://github.com/binhtran432k/ungrammar-language-features
--- Language Server for Ungrammar.
---
--- Ungrammar Language Server can be installed via npm:
--- ```sh
--- npm i ungrammar-languageserver -g
--- ```
return {
  cmd = { 'ungrammar-languageserver', '--stdio' },
  filetypes = { 'ungrammar' },
  settings = {
    ungrammar = {
      validate = {
        enable = true,
      },
      format = {
        enable = true,
      },
    },
  },
}
