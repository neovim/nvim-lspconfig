---@brief
---
--- https://github.com/snyk/snyk-ls
---
--- LSP for Snyk Open Source, Snyk Infrastructure as Code, and Snyk Code.
return {
  cmd = { 'snyk-ls' },
  root_markers = { '.git', '.snyk' },
  filetypes = {
    'go',
    'gomod',
    'javascript',
    'typescript',
    'json',
    'python',
    'requirements',
    'helm',
    'yaml',
    'terraform',
    'terraform-vars',
    'apex',
    'cpp',
    'cs',
    'dart',
    'elixir',
    'groovy',
    'java',
    'kotlin',
    'objc',
    'php',
    'rust',
    'ruby',
    'scala',
    'swift',
    'vb',    
  },
  settings = {},
  -- Configuration from https://github.com/snyk/snyk-ls#configuration-1
  init_options = {
    activateSnykCode = 'true',
  },
}
