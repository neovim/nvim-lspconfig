---@brief
---
--- https://www.npmjs.com/package/turbo-language-server
---
--- `turbo-language-server` can be installed via `npm`:
---
--- ```sh
--- npm install -g turbo-language-server
--- ```
---
--- or via `yarn`:
---
--- ```sh
--- yarn global add turbo-language-server
--- ```
return {
  cmd = { 'turbo-language-server', '--stdio' },
  filetypes = { 'html', 'ruby', 'eruby', 'blade', 'php' },
  root_markers = { 'Gemfile', '.git' },
}
