---@brief
---
--- https://www.npmjs.com/package/@herb-tools/language-server
--- https://github.com/marcoroth/herb
---
--- HTML+ERB (HTML + Embedded Ruby)
--- Powerful and seamless HTML-aware ERB parsing and tooling.
---
--- Herb is designed from the ground up to deeply understand `.html.erb` files,
--- preserving both HTML and embedded Ruby structure without losing any details.
---
--- `herb-language-server` can be installed via `npm`:
---
--- ```sh
--- npm install -g @herb-tools/language-server
--- ```
---
--- or via `yarn`:
---
--- ```sh
--- yarn global add @herb-tools/language-server
--- ```
return {
  cmd = { 'herb-language-server', '--stdio' },
  filetypes = { 'html', 'ruby', 'eruby' },
  root_markers = { 'Gemfile', '.git' },
}
