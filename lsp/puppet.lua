---@brief
---
--- LSP server for Puppet.
---
--- Installation:
---
--- - Clone the editor-services repository:
---     https://github.com/puppetlabs/puppet-editor-services
---
--- - Navigate into that directory and run: `bundle install`
---
--- - Install the 'puppet-lint' gem: `gem install puppet-lint`
---
--- - Add that repository to $PATH.
---
--- - Ensure you can run `puppet-languageserver` from outside the editor-services directory.
return {
  cmd = { 'puppet-languageserver', '--stdio' },
  filetypes = { 'puppet' },
  root_markers = {
    'manifests',
    '.puppet-lint.rc',
    'hiera.yaml',
    '.git',
  },
}
