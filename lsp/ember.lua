---@brief
---
--- https://github.com/ember-tooling/ember-language-server
---
--- `ember-language-server` can be installed via `npm`:
---
--- ```sh
--- npm install -g @ember-tooling/ember-language-server
--- ```
return {
  cmd = { 'ember-language-server', '--stdio' },
  filetypes = { 'handlebars', 'typescript', 'javascript', 'typescript.glimmer', 'javascript.glimmer' },
  root_markers = { 'ember-cli-build.js', '.git' },
}
