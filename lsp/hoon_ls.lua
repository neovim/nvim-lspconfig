---@brief
---
--- https://github.com/urbit/hoon-language-server
---
--- A language server for Hoon.
---
--- The language server can be installed via `npm install -g @hoon-language-server`
---
--- Start a fake ~zod with `urbit -F zod`.
--- Start the language server at the Urbit Dojo prompt with: `|start %language-server`
return {
  cmd = { 'hoon-language-server' },
  filetypes = { 'hoon' },
  root_markers = { '.git' },
}
