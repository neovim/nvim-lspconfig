---@brief
---
--- https://github.com/phpactor/phpactor
---
--- Installation: https://phpactor.readthedocs.io/en/master/usage/standalone.html#global-installation

return {
  cmd = { 'phpactor', 'language-server' },
  filetypes = { 'php' },
  root_markers = { '.git', 'composer.json', '.phpactor.json', '.phpactor.yml' },
  workspace_required = true,
}
