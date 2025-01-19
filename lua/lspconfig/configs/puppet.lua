local root_files = {
  'manifests',
  '.puppet-lint.rc',
  'hiera.yaml',
  '.git',
}

return {
  default_config = {
    cmd = { 'puppet-languageserver', '--stdio' },
    filetypes = { 'puppet' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ unpack(root_files) }, { path = fname, upward = true })[1])
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
LSP server for Puppet.

Installation:

- Clone the editor-services repository:
    https://github.com/puppetlabs/puppet-editor-services

- Navigate into that directory and run: `bundle install`

- Install the 'puppet-lint' gem: `gem install puppet-lint`

- Add that repository to $PATH.

- Ensure you can run `puppet-languageserver` from outside the editor-services directory.
]],
  },
}
