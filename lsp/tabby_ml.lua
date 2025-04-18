---@brief
---
--- https://tabby.tabbyml.com/blog/running-tabby-as-a-language-server
---
--- Language server for Tabby, an opensource, self-hosted AI coding assistant.
---
--- `tabby-agent` can be installed via `npm`:
---
--- ```sh
--- npm install --global tabby-agent
--- ```
return {
  cmd = { 'tabby-agent', '--lsp', '--stdio' },
  filetypes = {},
  root_markers = { '.git' },
}
