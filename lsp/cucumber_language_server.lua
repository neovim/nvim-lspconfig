---@brief
---
--- https://cucumber.io
--- https://github.com/cucumber/common
--- https://www.npmjs.com/package/@cucumber/language-server
---
--- Language server for Cucumber.
---
--- `cucumber-language-server` can be installed via `npm`:
--- ```sh
--- npm install -g @cucumber/language-server
--- ```
return {
  cmd = { 'cucumber-language-server', '--stdio' },
  filetypes = { 'cucumber' },
  root_markers = { '.git' },
}
