---@brief
---
--- https://github.com/neomutt/mutt-language-server
---
--- A language server for (neo)mutt's muttrc. It can be installed via pip.
---
--- ```sh
--- pip install mutt-language-server
--- ```

---@type vim.lsp.Config
return {
  cmd = { 'mutt-language-server' },
  filetypes = { 'muttrc', 'neomuttrc' },
  root_markers = { '.git' },
  settings = {},
}
