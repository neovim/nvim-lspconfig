---@brief
---
--- https://github.com/moetelo/twiggy
---
--- `twiggy-language-server` can be installed via `npm`:
--- ```sh
--- npm install -g twiggy-language-server
--- ```
return {
  cmd = { 'twiggy-language-server', '--stdio' },
  filetypes = { 'twig' },
  root_markers = { 'composer.json', '.git' },
}
